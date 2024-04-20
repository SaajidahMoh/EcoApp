//
//  LocationsDataService.swift
//  EcoApp
//
//  Created by Saajidah Mohamed on 20/04/2024.
//https://www.givefood.org.uk/api/2/docs/#foodbanks/search
//https://www.givefood.org.uk/api/2/docs/#foodbanks/search

import Foundation
import MapKit

class LocationsDataService{
    
    static let locations: [Location] = [
    Location(
        name: "Westminster",
    // cityName: ,
  address: "Westminster Chapel Buckingham Gate",
        cityName: "London",
      postcode: "SW1E 6BS",
        coordinates: CLLocationCoordinate2D(latitude: 51.49888499999999, longitude: -0.138101),
        phone: "02078341731 x224",
      email: "foodbank@westminsterchapel.org.uk",
       link:"https://westminsterchapel.org.uk/foodbank/"
    ),
    
    Location(
        name: "Waterloo",
    // cityName: ,
  address: "Oasis UK, Kennington Road",
        cityName: "London",
      postcode: "SW1E 6BS",
        coordinates: CLLocationCoordinate2D(latitude: 51.4981911, longitude: -0.1117999),
        phone: "02079214205",
      email: "foodbank@oasiswaterloo.org",
       link:"https://waterloo.foodbank.org.uk/give-help/donate-food/"
    ),
    
    Location(
        name:"Salvation Army",
  address:"101 Newington Causeway",
        cityName:"London",
      postcode:"SE1 6BN",
        coordinates: CLLocationCoordinate2D(latitude: 51.4965956, longitude: -0.099385),
        phone:"02073674500",
      email:"info@salvationarmy.org.uk",
       link:"https://www.salvationarmy.org.uk"
    ),
    
    Location(
         name:"Covent Garden",
   address:"Covent Garden Dragon Hall Trust, 17 Stukeley Street",
         cityName:"London",
       postcode:"WC2B 5LT",
         coordinates: CLLocationCoordinate2D(latitude: 51.5166471, longitude: -0.1225173),
         phone: "02074047274",
       email:"foodbank@cgcc.org.uk",
        link:"https://www.dragonhall.org.uk/food-bank"
     ),
    
    Location(
         name:"Central Southwark Community Hub",
   address:"St Giles Parish Hall, 161 Benhill Road",
         cityName:"London",
         postcode:"SE5 7LL",
         coordinates: CLLocationCoordinate2D(latitude: 51.4743088, longitude: -0.0864751),
         phone:"02077031653",
       email: "office@cschub.co.uk",
        link:"https://www.cschub.co.uk/what-we-do"
     ),
    
    Location(
        name:"Euston",
  address:"28 Phoenix Road",
        cityName: "London",
      postcode:"NW1 1TA",
        coordinates: CLLocationCoordinate2D(latitude:51.5303781, longitude: -0.1325498),
        phone:"07400053838",
      email:"info@euston.foodbank.org.uk",
       link:"https://euston.foodbank.org.uk/give-help/donate-food/"
    ),
    
    Location(
        name:"Camden Mobile",
  address: "2 Ossulston St, The Saint Pancras and Somers Town Living Centre",
cityName: "London",
      postcode:"NW1 1DF",
        coordinates: CLLocationCoordinate2D(latitude: 51.5310901, longitude:-0.129785),
        phone: "02070183730",
      email: "info@urbancommunityprojects.org.uk",
       link:"https://www.urbancommunityprojects.org.uk/camden-mobile-food-bank"
    ),
    
    Location(
        name: "Southwark",
  address: "121A Peckham High Street, Peckham",
cityName: "London",
      postcode:"SE15 5SE",
        coordinates: CLLocationCoordinate2D(latitude:51.4740883, longitude: -0.0679916),
        phone:"02077320007",
      email:"foodbank.support@pecan.org.uk",
       link:"https://southwark.foodbank.org.uk/give-help/donate-food/"
    ),
    
    Location(
        name:"St Mark's Church",
  address:"Battersea Rise",
cityName: "London",
      postcode: "SW11 1EJ",
        coordinates: CLLocationCoordinate2D(latitude: 51.4604982, longitude: -0.1702023),
        phone:"02073269428",
      email:"info@wandsworth.foodbank.org.uk",
       link:"https://wandsworth.foodbank.org.uk/give-help/donate-food/"
    ),
    
    Location(
        name: "Blessed Sacrament Catholic Church",
  address:"Copenhagen Street, Islington",
cityName: "London",
      postcode:"N1 0SR",
        coordinates: CLLocationCoordinate2D(latitude: 51.5368712, longitude: -0.11747),
        phone:"02072263277",
      email:"copenhagenstreet@rcdow.org.uk",
       link:"https://parish.rcdow.org.uk/copenhagenstreet/copenhagen-street-foodbank/"
    ),
    
    Location(
        name:"Hope Church Vauxhall",
  address:"105 Tyers Street",
cityName: "London",
      postcode:"SE11 5HS",
        coordinates: CLLocationCoordinate2D(latitude:  51.48902094591932, longitude: -0.1185164005111175), 
        phone:"02075822618",
      email:"info@hopevauxhall.co.uk",
       link:"https://norwoodbrixton.foodbank.org.uk/?ref=givefood.org.uk"
    )





    

    
    
    ]
}

