//
//  StatusMenuController.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa


final class StatusMenuController: NSObject {

	// MARK: Outlets
	
	@IBOutlet private weak var statusMenu: NSMenu!
	@IBOutlet private weak var statusChangeMenuButton: NSMenuItem!
	@IBOutlet private weak var lastUpdateMenuButton: NSMenuItem!
    @IBOutlet private weak var currenciesMenuAsset: NSMenuItem!
    @IBOutlet private weak var statisticMenuItem: NSMenuItem!
    @IBOutlet private weak var statisticMenuView: StatisticMenuView!

    // MARK: State Enumerations
	
	private enum TimerState {

		case updating
        case stopped

    }
	
	enum AppState<Coin> {

		case showing(Coin)
		case updating(String?)
		case error

    }

	// MARK: Constants and Variables

    private struct TimerInterval {

        static let basic: TimeInterval = 60
        static let short: TimeInterval = 5

    }

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
    private var timer: Timer?
	private var timerState: TimerState = .updating
	private var currentAppState: AppState<Coin> = .updating(nil)
    private var coins: [Coin]?
    private var currentCoinID: String? {
        didSet {
            guard let currentCoinID = currentCoinID else {
                switchAppState(to: .error)
                return
            }
            update()
            UserDefaults.currentCurrency = currentCoinID
        }
    }
    private var isConnectionLost = false

	// MARK: View Lifecycle
	
	override func awakeFromNib() {
        // Initializing status menu
		statusItem.menu = statusMenu

        // Constructing Current Menu from results that has been retrieved from remote server
        constructCurrencyMenu()

        // Starting from showing "Updating" status
		switchAppState(to: .updating(nil))

        currentCoinID = UserDefaults.currentCurrency
        
        // Init statistic menu item
        statisticMenuItem.view = statisticMenuView

        // Scheduling updates
        scheduleUpdates(timeInterval: TimerInterval.basic)
	}

	// MARK: Update Methods
    
    private func scheduleUpdates(timeInterval: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc private func update() {
        guard let currentCoinID = currentCoinID else {
            switchAppState(to: .error)
            return
        }
        CryptoAPI.fetchRates(currency: currentCoinID) { [weak self] result in
            guard let self = self else { return }
			switch result {
            case .success(let coin):
                guard let coin = coin else {
                    self.switchAppState(to: .error)
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.switchAppState(to: .showing(coin))
				}
			case .error(let error):
				NSLog(error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.switchAppState(to: .error)
                }
			case .customError(let customError):
				NSLog(customError)
			}
		}
	}

	// MARK: State Switchers
	
	private func switchMenuItemUpdate(to state: TimerState) {
		timerState = state
		switch timerState {
		case .updating:
			statusChangeMenuButton.title = NSLocalizedString("Pause Updates", comment: "A pause button in status menu.")
		case .stopped:
			statusChangeMenuButton.title = NSLocalizedString("Resume", comment: "A resume button in status menu.")
			invalidateTimer()
        }
	}
    
    private func switchAppState(to state: AppState<Coin>) {
        currentAppState = state
        switch currentAppState {
        case .showing(let coin):
            statusItem.title = coin.priceUSD.format(with: .currency)
            lastUpdateMenuButton.title = coin.lastUpdated.formattedAsStringDate
            statusItem.image = NSImage(named: coin.id) ?? NSImage(named: "default")
            statisticMenuView.render(coin)
            if isConnectionLost {
                constructCurrencyMenu()
                setTimerUpdateWith(timerInterval: TimerInterval.basic)
                isConnectionLost = false
            }
        case .updating(let coin):
            let coin = coin ?? "default"
            statusItem.image = NSImage(named: coin)
            statusItem.title = NSLocalizedString("Updating…", comment: "Title next to the rate, that indicates an update process.")
        case .error:
            if isConnectionLost == false {
                statusItem.image = NSImage(named: "connectionLost")
                setTimerUpdateWith(timerInterval: TimerInterval.short)
                isConnectionLost = true
            }
        }
    }

    // MARK: Timer
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setTimerUpdateWith(timerInterval: TimeInterval) {
        invalidateTimer()
        scheduleUpdates(timeInterval: timerInterval)
    }

    // MARK: Currencies Menu Construction
    
    private func constructCurrencyMenu() {
        currenciesMenuAsset.submenu?.removeAllItems()

        CryptoAPI.fetchTopCurrencies { result in
            switch result {
            case .success(let coins):
                self.coins = coins
                DispatchQueue.main.async {
                    coins.forEach { coin in
                        let menuItem = NSMenuItem(title: coin.name, action: #selector(self.selectItem), keyEquivalent: "")
                        menuItem.target = self
                        menuItem.isEnabled = true
                        if self.currentCoinID == coin.id {
                            menuItem.state = .on
                        }
                        self.currenciesMenuAsset.submenu?.addItem(menuItem)
                    }
                }
            case .error(let error):
                self.currenciesMenuAsset.submenu?.addItem(withTitle: "Cannot load currencies", action: nil, keyEquivalent: "")
                NSLog(error.localizedDescription)
            case .customError(let customError):
                NSLog(customError)
            }
        }
    }
    
    @objc func selectItem(_ item: NSMenuItem) {
        guard let id = coins?.first(where: { $0.name == item.title })?.id else { return }
        switchAppState(to: .updating(id))
        currentCoinID = id
        setMenuItemStateOn(for: item)
    }

    /// Finds the first previously selected element and turns it off. Selects the current element.
    private func setMenuItemStateOn(for item: NSMenuItem) {
        currenciesMenuAsset.submenu?.items.first { $0.state == .on }?.state = .off
        item.state = .on
    }

    // MARK: Status Menu Actions

    @IBAction func refreshClicked(_ sender: NSMenuItem) {
		update()
	}
	
	@IBAction func statusChangeClicked(_ sender: NSMenuItem) {
		switchMenuItemUpdate(to: timerState == .updating ? .stopped : .updating)
	}
	
	@IBAction func quitClicked(_ sender: NSMenuItem) {
		NSApplication.shared.terminate(self)
	}

}
