# Internal IT Support Ticketing System — Current Progress

## Project Overview

We are building a pure Salesforce-based Internal IT Support Ticketing System using:

- Salesforce Custom Objects
- Queues
- Flows
- Apex
- Quick Actions
- Console Navigation
- Hybrid UI Architecture

The system is designed incrementally, avoiding overengineering and introducing features only when needed.

---

# Current Architecture

## Application Type

Internal IT Support System

Employees can:
- create support tickets
- view their own tickets

Support agents can:
- work on queue tickets
- assign tickets to themselves
- update ticket status

---

# Core Object Created

## `Ticket__c`

Custom object used for handling internal support tickets.

---

# Fields Implemented

| Field | Type |
|---|---|
| Name | Auto Number |
| Title__c | Text |
| Description__c | Long Text Area |
| Status__c | Picklist |
| Priority__c | Picklist |
| Category__c | Picklist |

---

# Picklist Values

## Status

- Open
- In Progress
- Closed

---

## Priority

- Low
- Medium
- High

---

## Category

- Hardware
- Software
- Access
- Network
- Other

---

# Console Application

Created:

## `IT Support Console`

Using:
- Console Navigation

This provides a workspace-oriented support experience.

---

# Queue Architecture

## Queue Created

`IT Support Queue`

---

# What Are Queues in Salesforce?

Queues are shared work containers where records can wait until someone from a team picks them up.

Instead of assigning tickets directly to users:

```text
Ticket → Queue → Agent Picks Ticket
```

The queue temporarily owns the ticket using Salesforce standard `OwnerId`.

---

# Why We Used Queues

Queues provide multiple enterprise advantages:

## 1. Centralized Work Management

All unassigned tickets appear in one place.

Example:
- Hardware issues
- Software requests
- Access problems

can all be visible to support agents.

---

## 2. Better Scalability

Without queues:

```text
Ticket → Direct User Assignment
```

becomes difficult to manage at scale.

With queues:

```text
Ticket → Shared Queue
→ Best available agent picks ticket
```

This is far more maintainable.

---

## 3. Future AI Compatibility

Queue-based systems work extremely well with:
- AI triage
- Agentforce automation
- workload balancing
- intelligent routing
- escalations

because tickets remain unassigned until processed.

---

## 4. Cleaner Ownership Model

Current ownership lifecycle:

```text
New Ticket
→ Owner = IT Support Queue

Agent clicks "Assign To Me"
→ Owner = Support Agent
```

This uses Salesforce-native ownership architecture.

No custom assignment fields were required.

---

# Security Model

## Visibility Rules

Employees:
- can view only their own tickets

Support agents:
- can view queue tickets
- can work assigned tickets

Admins:
- full visibility

---

# Automation Implemented

## Record-Triggered Flow

Created flow:

```text
On Ticket Creation
→ Assign OwnerId to IT Support Queue
```

This ensures every new ticket automatically enters the support queue.

---

# Assign To Me Feature

Implemented using:

```text
Quick Action
→ Flow
→ Apex
```

---

# Feature Workflow

```text
Agent opens queue ticket
→ Clicks "Assign To Me"
→ Apex assigns OwnerId to current user
→ Status becomes "In Progress"
→ Flow sends notification email
```

---

# Why This Architecture Was Chosen

## Apex Handles

- business logic
- ownership updates
- status transitions

---

## Flow Handles

- orchestration
- notifications
- configurable automation

This separation creates a clean and scalable Salesforce-native architecture.

---

# Current System Workflow

```text
Employee creates ticket
→ Ticket automatically assigned to IT Support Queue
→ Agents see queue tickets
→ Agent clicks "Assign To Me"
→ Ticket assigned to agent
→ Status changes to In Progress
→ Email notification sent
```

---

# Technologies Used So Far

- Salesforce Custom Objects
- Lightning Console App
- Queues
- Flows
- Apex
- Quick Actions

---

# Current Status

The project now has a functioning support workflow foundation with:
- queue-based ticket management
- automated ownership routing
- support-agent assignment workflow
- notification handling
- enterprise-style console architecture

# Process Automation Settings vs Org-Wide Email Address in Salesforce

Both involve email addresses, but they serve different purposes in Salesforce.

---

# 1. Process Automation Settings Email

Location:

```text
Setup → Process Automation Settings
```

This email is mainly used as the default sender email for Salesforce automation.

Examples of automation:
- Flows
- Workflow Rules
- Process Builder
- Scheduled automation
- Approval processes

---

## Think of it as

> “Which email should Salesforce automation use by default?”

---

# Example

Suppose:

A Flow automatically sends:

```text
"Your ticket has been created."
```

No human clicked send.

Salesforce automation sends the email.

If Process Automation email is configured as:

```text
automation@xyz.com
```

Then customer sees:

```text
From: automation@xyz.com
```

---

# 2. Org-Wide Email Address

Location:

```text
Setup → Org-Wide Addresses
```

These are official company email addresses that:
- users
- Apex
- Flows
- Email Alerts

can explicitly send emails from.

---

## Think of it as

> “Which company email identities are allowed inside Salesforce?”

---

# Example

Support agent Rahul replies to customer.

Without Org-Wide Email:

```text
From: rahul@xyz.com
```

With Org-Wide Email:

```text
From: support@xyz.com
```

This looks much more professional.

---

# Real Company Example

Suppose your company has:

```text
support@xyz.com
hr@xyz.com
noreply@xyz.com
```

And users:
- Aakash
- Rahul
- Priya

---

# CASE 1 — Org-Wide Email Address

## Situation

Rahul is a support agent.

Customer sends complaint.

Rahul replies from Salesforce.

---

## Without Org-Wide Email

Customer sees:

```text
From: rahul@xyz.com
```

Problem:
- Looks personal
- Bad branding
- Customer may directly contact Rahul

---

## With Org-Wide Email

Rahul selects:

```text
support@xyz.com
```

Now customer sees:

```text
From: support@xyz.com
```

---

# KEY POINT

Here:
- A HUMAN USER is sending mail
- They choose a company email

👉 This is Org-Wide Email Address.

---

# CASE 2 — Process Automation Settings

Suppose:

When Ticket is created,
a Flow automatically sends:

```text
"Your ticket has been created."
```

No human involved.

Salesforce automation sends it.

---

If Process Automation email is configured as:

```text
automation@xyz.com
```

Customer sees:

```text
From: automation@xyz.com
```

---

# KEY POINT

Here:
- No user involved
- Salesforce automation sends the email

👉 This is Process Automation Settings.

---

# Important Relationship Between Them

Sometimes a Flow/Apex email can:
- explicitly use an Org-Wide Email Address
OR
- fall back to the Process Automation email

---

# Flow Decision Tree

```text
Did developer/admin explicitly choose Org-Wide Email?
          |
        YES
          |
Use that email (support@xyz.com)

          |
         NO
          |
Use Process Automation email
(automation@xyz.com)
```

---

# Important Verification Rule

A very important point:

❌ You cannot reliably use random unverified emails in Process Automation Settings.

The email should:
1. Exist as a valid email
2. Usually be verified
3. Must added as an Org-Wide Email Address

---

# Example

Suppose you enter:

```text
fakeemail@xyz.com
```

in Process Automation Settings.

But:
- email does not exist
- or is not verified
- or not configured properly

Then:
- Salesforce may fail sending emails
- emails may go to spam
- or Salesforce may not allow proper usage

---

# Best Practice

Always:

1. Add email in:
```text
Setup → Org-Wide Email Addresses
```

2. Verify the email

3. Then use it in:
```text
Process Automation Settings
```

---

# Best Practice Architecture

| Use Case | Recommended |
|---|---|
| Customer support emails | Org-Wide Email |
| HR emails | Org-Wide Email |
| Invoice emails | Org-Wide Email |
| Generic automation notifications | Process Automation |
| Flow fallback sender | Process Automation |

---

# Simplest Memory Trick

| Feature | Meaning |
|---|---|
| Org-Wide Email | “Official selectable company email” |
| Process Automation Email | “Default automation/robot sender” |

---

# Final One-Line Difference

| Feature | Purpose |
|---|---|
| Org-Wide Email | Explicit business email identity |
| Process Automation Email | Default sender for Salesforce automation |


# Trigger
Currently Implemented a Trigger in which user is unable to move ticket from a open to closed directly 
Only few transition methods are allowed 

