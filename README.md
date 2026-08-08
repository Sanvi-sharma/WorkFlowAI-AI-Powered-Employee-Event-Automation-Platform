# Registration Automation System Technical Design & Implementation Documentation

Automated pipeline that turns Google Form registrations into verified event
registrations with QR codes, and dispatches confirmation emails/WhatsApp
messages — no manual data entry or copy-pasting required.

---

## Overview

This project automates event/workshop registration 
It replaces a manual process of checking form responses, 
generating registration IDs, creating QR codes, and 
emailing/WhatsApp-ing confirmations one by one.

It is built as **two connected n8n workflows**:

1. **Registration Processing** — validates new sign-ups, generates a unique
   Registration ID, generates a QR code, and writes everything back to Google
   Sheets.
2. **Notification Dispatch** — watches the sheet for updates and sends
   confirmation emails and WhatsApp messages, reminders then marks 
   each row as sent.

---

## Architecture

```
                    ┌────────────────────── WORKFLOW 1: Registration 
                    
                    ──────────────────────┐
Google Form ──▶ Normalize ──▶ Validate ──▶ Reg ID Verification (switch)
 Response         Student       Student           │
                    Data          Data      ┌──────┴──────┐
                                             │             │
                                     [ID exists]     [ID missing/new]
                                             │             │
                                    Set reg status    Get row(s) in sheet
                                     t              │
                                                     Generate Registration ID (JS)
                                                              │
                                                     Generate QR Code (HTTP)
                                                              │
                                                     Update Reg ID + QR in sheet
                                                              │
                                                     Generate Metadata
                                                              │
                                                     Finalise sheet
                                             └──────────────┘
                                                     │
                                                     ▼
                    ┌────────────────────── WORKFLOW 2: Notification ──────────────────────┐
        Sheet Updated (trigger: rowAdded)
                     │
              email_status (switch)
              │              │
        [pending]        [already sent / other]
              │              │
       Event config    whatsapp_status (switch)
              │              │
        Send an Email   Send message (WhatsApp)
              │
       Update email_status in sheet
```

*(Add an actual screenshot of each n8n canvas here — `docs/screenshots/`)*
![alt text](<Screenshot from 2026-08-08 21-49-55.png>)

![alt text](<Screenshot from 2026-08-08 21-49-47.png>)
---

## Prerequisites

- n8n version: `TODO` (self-hosted or n8n Cloud — note version, you're on
  `localhost:5678` so likely self-hosted)
- Google account with access to the source Google Form + Google Sheet
- Google Sheets OAuth2 credential configured in n8n
- Email sending credential (SMTP / Gmail OAuth2 — `TODO: confirm which`)
- WhatsApp Business API / Twilio / whichever provider powers the
  "Send message" node — `TODO: confirm provider`
- QR code generation API — the "Generate QR Code" node calls
  `TODO: full endpoint (seen as api.qrserver.com in the workflow)`

---

## Setup

1. **Import workflows**
   - Import `workflows/registration-processing.json`
   - Import `workflows/notification-dispatch.json`

2. **Connect credentials**
   In n8n, open each Google Sheets / Gmail / WhatsApp node and attach your
   own credentials. Never commit real credentials or API keys to this repo.

3. **Configure the Google Sheet**
   - `TODO: Sheet name/ID`
   - Required columns: `row_number`, `Email Address`, `email_status`,
     `whatsapp_status`, Registration ID, QR Code, and any metadata fields
     used by "Generate Metadata."

4. **Set trigger sources**
   - Workflow 1 trigger: Google Sheets (Google Form responses feed)
   - Workflow 2 trigger: Google Sheets, `rowAdded` event on the same/linked
     sheet

5. **Activate both workflows**
   Toggle "Publish"/Active in n8n so the triggers run automatically instead
   of only on manual execution.

---

## Node-by-node reference

### Workflow 1 — Registration Processing

| Node | Type | Purpose |
|---|---|---|
| Google form responses | Trigger (Sheets) | Fires when a new form response row is added |
| Normalize Student Data | Set/Edit Fields | Cleans and standardizes incoming fields |
| Validate Student Data | IF | Checks required fields are present/valid |
| Reg ID Verification | Switch | Checks if a Registration ID already exists for this entry |
| Get row(s) in sheet | Google Sheets (Read) | Pulls existing rows to compute the next row number |
| Generate Registration ID | Code (JS) | Builds a unique Registration ID |
| Generate QR Code | HTTP Request | Calls QR API to generate a code from the Registration ID |
| Update reg ID and QR code | Google Sheets (Update) | Writes ID + QR code back to the sheet |
| Generate Metadata | Set/Edit Fields | Builds additional metadata for the record |
| Finalise sheet | Google Sheets (Update) | Final write marking the row complete |
| Set reg status to invalid | Google Sheets (Update) | Marks duplicate/invalid entries |

### Workflow 2 — Notification Dispatch

| Node | Type | Purpose |
|---|---|---|
| Extract data from updated sheet | Trigger (Sheets, rowAdded) | Fires when Workflow 1 finishes updating a row |
| email_status | IF | Routes based on whether email is pending or already sent |
| Event configuration | Set/Edit Fields | Prepares email parameters (subject, body, recipient) |
| Send an Email | Email/Gmail | Sends the confirmation email |
| update email_status | Google Sheets (Update) | Marks the row's email as "Sent" |
| whatsapp_status | IF | Routes based on WhatsApp send status |
| Send message | WhatsApp | Sends the confirmation via WhatsApp |

---

## Configuration variables

Create a `.env.example` (do **not** commit real values) with:

```
GOOGLE_SHEETS_SPREADSHEET_ID=
QR_CODE_API_ENDPOINT=
EMAIL_FROM_ADDRESS=
WHATSAPP_API_TOKEN=      # or Twilio SID/Auth token, per provider
```

---

## Usage

1. A participant submits the Google Form.
2. Workflow 1 runs automatically: validates the entry, generates a
   Registration ID + QR code, and writes it to the sheet.
3. Workflow 2 detects the new/updated row and sends the confirmation email
   and WhatsApp message, then flips `email_status`/`whatsapp_status` to
   "Sent" so nothing gets double-sent.

```
                                    Google Form
                                        │
                                        ▼
                                    Google Sheets
                                        │
                                        ▼
                                Generate Registration ID
                                        │
                                        ▼
                                    Generate QR
                                        │
                                        ▼
                                    Update Sheet
                                        │
                                        ▼
                                Send Premium HTML Mail
                                        │
                                        ▼
                                Send WhatsApp Confirmation
                                        │
                                        ▼
                                Reminder - 3 Days Before
                                        │
                                        ▼
                                Reminder - 1 Day Before
                                        │
                                        ▼
                                Reminder - 2 Hours Before
                                        │
                                        ▼
                                QR Scan at Entry
                                        │
                                        ▼
                                Attendance Marked Automatically
                                        │
                                        ▼
                                Certificate Generated
                                        │
                                        ▼
                                Certificate Mail
                                        │
                                        ▼
                                LinkedIn Feedback Automation
                                        │
                                        ▼
                                Student Database Updated
```

---

## Limitations / Known issues

- `TODO`: note any rate limits on the QR API or WhatsApp provider
- `TODO`: what happens if Send an Email fails — is there a retry?
- Duplicate form submissions rely on "Reg ID Verification" catching repeats
  by [whatever field you're matching on — email? name? `TODO`]

---

## Repo structure

```text
Automation-Lab/
│
├── docs/
│   ├── 00-Directory-structure.md
│   ├── 01-setup.md
│   ├── 02-docker-fundamentals.md
│   ├── 03-docker-compose.md
│   ├── 04-n8n-basics.md
│   ├── 05-google-sheets.md
│   ├── 06-whatsapp-automation.md
│   ├── 07-ai-agents.md
│   ├── 08-production-deployment.md
│   ├── 09-git-&-github-fundamentals.md
│   └── architecture.md
│   └── workflows.md
│   └── troubleshooting.md
│   └── glossary.md
│
├── n8n/
│   ├── docker-compose.yml
│   ├── .env
│   ├── data/
│   └── backups/
│
├── evolution/
│   ├── docker-compose.yml
│   ├── .env
│   └── data/
│
├── shared/
│   ├── uploads/
│   ├── ssl/
│   └── scripts/
│
├── assests/
│   ├── diagrams/
│   └── screenshots/
│
├── LICENSE
├── n8n workflow automation.txt
├── .gitignore
│
└── README.md
```

---

## License

`TODO: add a license (MIT is a common default for automation templates)`