//
//  ViewController.swift
//  RouteMapApp
//
//  Created by Александр Макаров on 05.11.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()

    private lazy var addAddressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.setTitle("add address", for: .normal)
        return button
    }()
    
    private lazy var routeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.setTitle("route", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.setTitle("reset", for: .normal)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews(mapView, addAddressButton, routeButton, resetButton)
        setConstraints()
        
        addAddressButton.addTarget(self, action: #selector(addAddressButtonDidTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonDidTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func addAddressButtonDidTapped() {
        alertAddAddress(title: "Добавить", placeholder: "Введите адрес") { text in
            print(text)
        }
    }
    
    @objc private func routeButtonDidTapped() {
        print("route button did tapped")
    }
    
    @objc private func resetButtonDidTapped() {
        print("reset button did tapped")
    }
}

extension ViewController {
    private func setConstraints() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        addAddressButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            addAddressButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            addAddressButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addAddressButton.heightAnchor.constraint(equalToConstant: 50),
            addAddressButton.widthAnchor.constraint(equalToConstant: 120),
            
            routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            routeButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            routeButton.heightAnchor.constraint(equalToConstant: 50),
            routeButton.widthAnchor.constraint(equalToConstant: 120),
            
            resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
}

