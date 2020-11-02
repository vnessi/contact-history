# Add Status History to Contacts with the following requirements

# Proposal

A client requires us to add a Status History to Contacts with the following requirements.

Each Status has a Name (Prospect, Active, Suspended), a Begin Date (2020-10-01) and an End Date and we should be able to see the Status History on the Contact layout. 

If a Status is current, the End Date will be empty.

Status dates cannot overlap.

For example:
From 2020-01-01 to 2020-02-01 - Prospect
From 2020-02-01 to today - Active

# Solution

**Scratch org login credentials** 

https://test.salesforce.com -> test-dcqutgq93kcs@example.com // $oUi(P%3b8

Schema change

![alt text](https://github.com/vnessi/contact-history/blob/master/schema%20change.png?raw=true)

Trigger

![alt text](https://github.com/vnessi/contact-history/blob/master/trigger.png?raw=true)

How it looks like in action

![alt text](https://github.com/vnessi/contact-history/blob/master/statusHistry.png?raw=true)
