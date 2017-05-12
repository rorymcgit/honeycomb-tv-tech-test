# Honeycomb Engineering Test - Makers Edition

### Instructions for Use

- Clone this repo
- Run `bundle` to install dependencies
- Run `ruby run.rb` to create an order and have it printed to the terminal

To run tests:
- Run `rspec`

### My Approach

I approached this challenge by trying to understand how the desired system would be used.  
After reading the spec several times, following the flow of the existing code, playing around with adding orders/deliveries/broadcasters I deduced the following:
- Discounts may change over time, or on a client-by-client basis
- There are 4 discount parameters:
  - Bulk discount threshold: `$30`
  - The percentage reduction a bulk discount provides: `10%`
  - How many deliveries provide a reduction in the express delivery price: `>1`
  - What price to thereby reduce the express delivery to: `$15`
- The price of the express delivery already added to the order must be altered when a second one is added
- There should be information on the invoice output detailing what discounts, if any, were applied

### My Solution

The Discount class I created can be instantiated with variable discount parameters. These will default to the current discount’s parameters but can be overridden by providing arguments on instantiation. They may also be changed after Discount’s instantiation, and after Order has been instantiated with Discount by reassigning `order.discount.<discount_parameter>` to the new figure.  

### API

To create an order, a discount must first be instantiated. If no arguments are provided on instantiation, the default parameters are used.
The arguments should be provided in the following order:  
    - bulk discount threshold  
    - bulk reduction percentage  
    - multiple delivery threshold  
    - discounted express price

`material = Material.new('WNP/SWCL001/010')`  
`discount = Discount.new`  
`order = Order.new(material, discount)`  

For a custom discount:  
`big_discount = Discount.new(20, 50, 1, 12)`  
As above, the discount instance is passed into the instantiation of Order as its second argument.  
`big_discounted_order = Order.new(material, big_discount)`  

When an express delivery is added to the order, the order delegates to the Discount class to evaluate the eligibility for the multiple express delivery discount.  

When total_cost is called, the order asks the Discount class to evaluate its eligibility for a bulk discount.  

When output is called, a new instance of the Printer class is injected, which takes some responsibility away from the Order class.  

### Examples
![](https://github.com/rorymcgit/honeycomb-tv-tech-test/blob/master/eg_WNP-SWCL001-010.png)
![](https://github.com/rorymcgit/honeycomb-tv-tech-test/blob/master/eg_ZDW-EOWW005-010.png)


### Other Thoughts
I focussed on reusability, for example the method checking for multiple_deliveries can be used to check for multiples of any kind of delivery.  

I considered putting a guard clause on the add method to prevent duplication of a broadcaster, however I felt that this was off spec.  

I understand I have set the bulk discount threshold to be over $30 and not "$30 or over". I followed the spec's wording literally in this case.

---
---

## The challenge

We have a system that delivers advertising materials to broadcasters.

Advertising Material is uniquely identified by a 'Clock' number e.g.

* `WNP/SWCL001/010`
* `ZDW/EOWW005/010`

Our sales team have some new promotions they want to offer so
we need to introduce a mechanism for applying Discounts to orders.

Promotions like this can and will change over time so we need the solution to be flexible.

### Broadcasters

These are the Broadcasters we deliver to

* Viacom
* Disney
* Discovery
* ITV
* Channel 4
* Bike Channel
* Horse and Country


### Delivery Products

* Standard Delivery: $10
* Express Delivery: $20

### Discounts

* Send 2 or more materials via express delivery and the price for express delivery drops to $15
* Spend over $30 to get 10% off

### What we want from you

Provide a means of defining and applying various discounts to the cost of delivering material to broadcasters.

We don't need any UI for this, we just need you to show us how it would work through its API.

## Examples

Based on the both Discounts applied, the following examples should be valid:

* send `WNP/SWCL001/010` to Disney, Discovery, Viacom via Standard Delivery and Horse and Country via Express Delivery
    based on the defined Discounts the total should be $45.00

* send `ZDW/EOWW005/010` to Disney, Discovery, Viacom via Express Delivery
     based on the defined Discounts the total should be $40.50
