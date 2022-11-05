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
    
    // MARK: - private propeprties
    
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
    
    private var annotationsArray: [MKPointAnnotation] = []
    
    // MARK: - override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupSubviews(mapView, addAddressButton, routeButton, resetButton)
        setConstraints()
        
        addAddressButton.addTarget(self, action: #selector(addAddressButtonDidTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonDidTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonDidTapped), for: .touchUpInside)
    }
    
    // MARK: - private methods
    
    // Метод создания точки для маршрута
    private func setupPlacemark(addressPlace: String) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressPlace) { [unowned self] (placemarks, error) in
            if let error = error {
                print(error)
                alertError(title: "Ошибка", message: "Сервер не доступен. Попробуйте добавить адрес еще раз")
                return
            }
            
            // Создаем группу плэйсмарков
            guard let placemarks = placemarks else { return }
            // Выбираем первый плэйсмарк из группы
            let placemark = placemarks.first
            // Создаем аннотицию
            let annotation = MKPointAnnotation()
            // Присваиваем заголовок аннотации
            annotation.title = addressPlace
            // Извлекаем из локацию из плэйсмарка
            guard let placemarkLocation = placemark?.location else { return }
            // Присваем координаты из плэйсмарка в координаты аннотации
            annotation.coordinate = placemarkLocation.coordinate
            
            // Создаем массив в котором будем хранить аннотации
            annotationsArray.append(annotation)
            if annotationsArray.count > 2 {
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            // отображаем аннотации
            mapView.showAnnotations(annotationsArray, animated: true)
        }
    }
    
    // Создаем запрос на получение маршрута из первой точки во вторую
    private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        // Стартовая координата
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        // Конечная координата
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        //Создаем и настраиваем запрос
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        // Запрашиваем маршрут
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            // Обработка ошибка
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                self.alertError(title: "Ошибка", message: "Маршрут не доступен")
                return
            }
            // Минимальный по длине маршрут первый если он всего один
            var minRoute = response.routes[0]
            
            // Определяем минимальный маршрут из доступных
            for route in response.routes{
                minRoute = route.distance < minRoute.distance ? route : minRoute
            }
            // отображаем маршрут
            self.mapView.addOverlay(minRoute.polyline)
        }
    }
    
    // Метод для кнопки добавления точки
    @objc private func addAddressButtonDidTapped() {
        alertAddAddress(title: "Добавить", placeholder: "Введите адрес") { [unowned self] text in
            setupPlacemark(addressPlace: text)
        }
    }
    
    // Метод для кнопки создания маршрута
    @objc private func routeButtonDidTapped() {
        // прокладываем маршруты
        for i in 0...annotationsArray.count - 2 {
            createDirectionRequest(startCoordinate: annotationsArray[i].coordinate, destinationCoordinate: annotationsArray[i + 1].coordinate)
        }
        
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    @objc private func resetButtonDidTapped() {
        // Очищаем наложенные маршруты
        mapView.removeOverlays(mapView.overlays)
        // Очищаем аннотации
        mapView.removeAnnotations(mapView.annotations)
        // Присваиваем аннотациям пустой массив
        annotationsArray = []
        // Скрываем кнопки
        routeButton.isHidden = true
        resetButton.isHidden = true
    }
}

// MARK: - MKMapViewDelegate extension

extension ViewController: MKMapViewDelegate {
    // Метод отрисовки маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
}

// MARK: - layout extension

extension ViewController {
    // Настройка констрейнтов
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
    // Добавляет сабвью к вью
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
}

