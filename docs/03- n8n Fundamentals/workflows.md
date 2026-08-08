```
Google Form
      │
      ▼
Google Sheet Trigger
      │
      ▼
Normalize
      │
      ▼
Validate
      │
      ▼
Metadata
      │
      ▼
Generate Student ID
      │
      ▼
Gemini AI
      │
      ▼
WhatsApp
      │
      ▼
Email
      │
      ▼
Google Drive Folder
      │
      ▼
CRM
      │
      ▼
Google Sheet Update  ← only once

```

Google Sheets Trigger
        │
Normalize Student Data
        │
Validate Student Data
        │
IF Registration ID Empty
        │
True
        │
Extract No. of Rows
        │
Generate Registration ID
        │
        ├──────────────┐
        │              │
Validate Student Data  │
        │              │
        ▼              ▼
              Merge
                │
                ▼
         Update Google Sheet
                │
                ▼
        Generate Metadata
                │
                ▼
            AI Agent

newwww workfloww

            Validate Student Data
      ├── True
      │      ↓
      │ Generate Student ID
      │      ↓
      │ Update Google Sheet
      │      ↓
      │ Send Confirmation Email
      │      ↓
      │ Send WhatsApp
      │
      └── False
             ↓
       Generate Validation Report
             ↓
       Update Google Sheet
             ↓
       Notify Student (optional)
             ↓
       Notify Admin (optional)