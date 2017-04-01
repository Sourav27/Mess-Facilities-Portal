# Mess and Facilities Portal - IIT Madras

## Description

This application is used to register complaints and feedback regarding Mess and Facilities in IIT Madras. Any student facing any issue with their service can contact the authorities directly and receive prompt responses.

## System dependencies

This application currently works with:

* Ruby 2.3.x
* Rails 5.0.x
* MySQL

## Installation

After cloning this repository, install the gems required for the app.
```
cd Mess-Facilities-Portal
bundle install
```
# Database initialization
Add MySQL credentials to database.yml and then setup the database
```
cp config/database.yml.temp config/database.yml
rails db:setup
```
# Deployment
```
rails s
```
