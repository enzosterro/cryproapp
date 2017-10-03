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
	
	// MARK: - State Enumerations
	
	enum MainAppState {
		case updating, stopped
	}
	
	enum RateLabelState<String> {
		case showing(String)
		case updating
		case error
	}
	
	// MARK: - Constants and Variables
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	let cryptoAPI = CryptoAPI()
	var timer: Timer! = nil
	var timerState: MainAppState = .updating
	var rateState: RateLabelState<String> = .updating
	var currentCoin = CoinModel.id.ethereum
	
	// MARK: - View Lifecycle
	
	override func awakeFromNib() {
		self.statusItem.menu = statusMenu
		self.statusItem.image = NSImage(named: NSImage.Name("menubar"))
		self.switchRateLabelState(to: .updating)
		self.scheduleUpdates()
	}
	
	// MARK: - Update Methods
	
	@objc private func update() {
		cryptoAPI.fetchRates() { result in
			switch result {
			case .success(let coins):
				for coin in coins where coin.id == self.currentCoin.rawValue {
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.switchRateLabelState(to: .showing(coin.price_usd))
						self.lastUpdateMenuButton.title = coin.last_updated.formattedDate
					}
				}
			case .error(let error):
				NSLog(error.localizedDescription)
			case .customError(let customError):
				NSLog(customError)
			}
		}
	}

	private func scheduleUpdates() {
		self.update()
		timer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(update), userInfo: nil, repeats: true)
	}
	
	// MARK: - State Handlers
	
	private func switchTimerState(to state: MainAppState) {
		self.timerState = state
		switch self.timerState {
		case .updating:
			self.statusChangeMenuButton.title = NSLocalizedString("Pause", comment: "A pause button in status menu.")
			self.scheduleUpdates()
		case .stopped:
			self.statusChangeMenuButton.title = NSLocalizedString("Resume", comment: "A resume button in status menu.")
			if self.timer.isValid {
				self.timer.invalidate()
			}
		}
	}
	
	private func switchRateLabelState(to state: RateLabelState<String>) {
		self.rateState = state
		switch self.rateState {
		case .showing(let price):
			self.statusItem.title = price.formattedString
		case .updating:
			self.statusItem.title = NSLocalizedString("Updating…", comment: "Title next to the rate, that indicates an update process.")
		case .error:
			self.statusItem.title = NSLocalizedString("Error", comment: "Title next to the rate, that indicates an error due connection problems.")
		}
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
