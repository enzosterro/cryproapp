//
//  StatusMenuController.swift
//  Etherium
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {

	// MARK: - Outlets
	
	@IBOutlet weak var statusMenu: NSMenu!
	@IBOutlet weak var statusChangeMenuButton: NSMenuItem!
	@IBOutlet weak var lastUpdateMenuButton: NSMenuItem!
    @IBOutlet weak var currenciesMenuAsset: NSMenuItem!
    @IBOutlet weak var statisticMenuItem: NSMenuItem!
    @IBOutlet weak var statisticMenuView: StatisticMenuView!
    
    // MARK: - State Enumerations
	
	enum MainAppState {
		case updating, stopped
	}
	
	enum RateLabelState<T> {
		case showing(Coin)
		case updating(CoinModel.name)
		case error
	}
	
	// MARK: - Constants and Variables
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	let cryptoAPI = CryptoAPI()

    let updateInterval: TimeInterval = 60
	var timer: Timer! = nil
	var timerState: MainAppState = .updating
	var rateState: RateLabelState<CoinModel.name> = .updating(.undefined)
    var currentCoin: CoinModel.name = .undefined {
        didSet {
            self.update()
            UserDefaults.setCurrentCurrency(currentCoin)
        }
    }
	
	// MARK: - View Lifecycle
	
	override func awakeFromNib() {
        
        // Initializing status menu
		self.statusItem.menu = statusMenu
        
        // Loading current currency from UserDefault store
        self.currentCoin = UserDefaults.getCurrentCurrency()
        
        // Constructing Current Menu from results that has been retrieved from remote server
        self.constructCurrencyMenu()
        
        // Starting from showing "Updating" status
		self.switchRateLabelState(to: .updating(currentCoin))
        
        // Init statistic menu item
        statisticMenuItem.view = statisticMenuView
     
        // Scheduling updates
        self.scheduleUpdates()
	}
	
	// MARK: - Update Methods
    
    private func scheduleUpdates() {
        timer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
	@objc private func update() {
        cryptoAPI.fetchRatesFor(currency: currentCoin) { result in
			switch result {
            case .success(let coins):
                guard let coin = coins.first else {
                    NSLog("Couldn't retrieve information from server.")
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.switchRateLabelState(to: .showing(coin))
				}
			case .error(let error):
				NSLog(error.localizedDescription)
			case .customError(let customError):
				NSLog(customError)
			}
		}
	}

	// MARK: - State Handlers
	
	private func switchTimerState(to state: MainAppState) {
		self.timerState = state
		switch self.timerState {
		case .updating:
			self.statusChangeMenuButton.title = NSLocalizedString("Pause Updates", comment: "A pause button in status menu.")
			self.scheduleUpdates()
		case .stopped:
			self.statusChangeMenuButton.title = NSLocalizedString("Resume", comment: "A resume button in status menu.")
			if self.timer.isValid {
				self.timer.invalidate()
			}
		}
	}
	
	private func switchRateLabelState(to state: RateLabelState<CoinModel.name>) {
		self.rateState = state
		switch self.rateState {
		case .showing(let coin):
			self.statusItem.title = coin.price_usd.formattedString
            self.lastUpdateMenuButton.title = coin.last_updated.formattedDate
            self.statisticMenuView.configureWith(coin: coin)
            
//            self.statusItem.image = coin.icon   // rewrite to not set icon every time
		case .updating(let coin):
            self.statusItem.image = NSImage(named: NSImage.Name(coin.rawValue))
            // Hiding the coin image while in updating process if it's not nil
//            if self.statusItem.image != nil { self.statusItem.image = nil }
			self.statusItem.title = NSLocalizedString("Updating…", comment: "Title next to the rate, that indicates an update process.")
		case .error:
			self.statusItem.title = NSLocalizedString("Error", comment: "Title next to the rate, that indicates an error due connection problems.")
		}
	}
    
    // MARK: - Currencies Menu Construction
    
    private func constructCurrencyMenu() {
        cryptoAPI.fetchRatesFor(topCurrencies: true) { result in
            switch result {
            case .success(let coins):
                DispatchQueue.main.async {
                    self.currenciesMenuAsset.submenu?.autoenablesItems = false
                    for coin in coins {
                        let menuItem = NSMenuItem(title: coin.name, action: #selector(self.selectCurrency), keyEquivalent: "")
                        if self.currentCoin.rawValue == coin.name.lowercased() { menuItem.state = .on }
                        menuItem.target = self
                        menuItem.isEnabled = true
                        self.currenciesMenuAsset.submenu?.addItem(menuItem)
                    }
                }
            case .error(let error):
                NSLog(error.localizedDescription)
            case .customError(let customError):
                NSLog(customError)
            }
        }
    }
    
    @objc func selectCurrency(menuItem: NSMenuItem) {
        if let coinModel = CoinModel.name(rawValue: menuItem.title.replacingOccurrences(of: " ", with: "-").lowercased()) {
            self.currentCoin = coinModel
            self.switchRateLabelState(to: .updating(coinModel))
            self.setMenuItemStateOnFor(item: menuItem)
        } else {
            NSLog("Couldn't instantiate currency from model's title: %@.", menuItem.title)
        }
    }
    
    private func setMenuItemStateOnFor(item: NSMenuItem) {
        guard let menuItems = self.currenciesMenuAsset.submenu?.items else { return }
        for menuItem in menuItems where menuItem.state == .on {
            menuItem.state = .off
            break
        }
        item.state = .on
    }
    
    // MARK: - Status Menu Actions

    @IBAction func refreshClicked(_ sender: NSMenuItem) {
		self.update()
	}
	
	@IBAction func statusChangeClicked(_ sender: NSMenuItem) {
		self.switchTimerState(to: timerState == .updating ? .stopped : .updating)
	}
	
	@IBAction func quitClicked(_ sender: NSMenuItem) {
		NSApplication.shared.terminate(self)
	}
}
