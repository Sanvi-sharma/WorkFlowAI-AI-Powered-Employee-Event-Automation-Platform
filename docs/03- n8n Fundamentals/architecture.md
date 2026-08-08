# Architecture
```
Google Sheets Trigger
        │
Normalize Student Data
        │
Validate Student Data
        │
Generate Metadata
        │
Generate Student ID
        │
Google Gemini Chat Model
        │
AI Agent / Basic LLM Chain
        │
Parse JSON
        │
WhatsApp
Email
Google Sheets
CRM
```

```
Google Sheets Trigger
        │
Normalize
        │
Validate
        │
IF Student_ID is empty
      /           \
Yes               No
 │                 │
Get Rows           │
 │                 │
Find Highest ID    │
 │                 │
Generate New ID    │
 │                 │
Update Sheet       │
 └────────────┬────┘
              ▼
      Generate Metadata
              ▼
         AI Personalization
              ▼
     WhatsApp + Email + CRM
    
```

Google Form
      ↓
Google Sheets Trigger
      ↓
Normalize
      ↓
Validate
      ↓
IF Student_ID is empty
      ↓
Google Sheets (Get Rows)
      ↓
Find Highest Student ID
      ↓
Generate Next Student ID
      ↓
Update Current Row
      ↓
Generate Metadata
      ↓
AI Personalization
      ↓
WhatsApp
      ↓
Email