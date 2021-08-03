### v1.0.1

Release Update - 6th December 2017

#### New Features

* Completed initial reference terraform creating an example of the three VPC per account model being suggested
  by Cloud Services and Domain Architecture.
* Creates two application environment VPCs and an associated management VPC.
* Automatically setup of peering between local VPCs and has the capability to peer with Cloud Services VPCs providing
  internet, shared and management services.
* Bug fix to ensure that peering between pdu's accounts isn't recreated on each apply.

#### Documentation

* Basic [readme](./README.md) documentation in place.