# Google Sheets Node -- Complete Reference

## Objective

Explain the Google Sheets node in n8n end-to-end: setting up credentials
via Google Cloud Console (OAuth2 and Service Account methods), every
operation available, and every parameter/setting you'll encounter --
using the registration/notification workflows in this project as
running examples.

------------------------------------------------------------------------

# Prerequisites

-   `n8n_localhost_setup_windows.md` / `n8n_localhost_setup_linux.md`
    completed, n8n reachable at `localhost:5678`
-   A Google account with access to Google Cloud Console
-   The target Google Sheet already created (or permission to create one)

------------------------------------------------------------------------

# 1. Setting Up Credentials via Google Cloud Console (OAuth2)

This is the recommended method for interactive/human-linked sheets
(what your workflows use).

## 1.1 Create a Google Cloud Project

1. Go to <https://console.cloud.google.com/>
2. Click the project dropdown (top left) → **New Project**
3. Name it, e.g. `automation-lab-n8n`
4. Click **Create**, wait for it to finish, then select it

## 1.2 Enable the Required APIs

1. In the left sidebar: **APIs & Services** → **Library**
2. Search for and enable:
   -   **Google Sheets API**
   -   **Google Drive API** *(required -- n8n uses Drive API to list/
       search sheets in the node's file picker)*

## 1.3 Configure the OAuth Consent Screen

1. **APIs & Services** → **OAuth consent screen**
2. User Type:
   -   **Internal** -- only if using a Google Workspace org account
   -   **External** -- for personal Gmail accounts (most common for
       local/dev setups)
3. Fill in:
   -   App name (e.g. `Automation Lab n8n`)
   -   User support email
   -   Developer contact email
4. Scopes: add
   -   `.../auth/spreadsheets`
   -   `.../auth/drive.file` (or broader `.../auth/drive` if you need
       to browse existing files, not just ones n8n creates)
5. Test users (if in "Testing" publish status): add your own Google
   account email so you're allowed to authorize the app
6. Save

## 1.4 Create OAuth2 Client Credentials

1. **APIs & Services** → **Credentials** → **Create Credentials** →
   **OAuth client ID**
2. Application type: **Web application**
3. Name: e.g. `n8n-sheets-client`
4. **Authorized redirect URIs** -- this must exactly match n8n's OAuth
   callback URL. In n8n, open the Google Sheets credential screen
   first; it displays the exact redirect URI to copy, typically:

```text
http://localhost:5678/rest/oauth2-credential/callback
```

5. Click **Create**. Copy the **Client ID** and **Client Secret** shown.

## 1.5 Add the Credential in n8n

1. In any Google Sheets node → **Credential** dropdown → **Create New**
2. Choose **Google Sheets OAuth2 API**
3. Paste **Client ID** and **Client Secret** from step 1.4
4. Click **Connect my account**
5. Complete the Google sign-in/consent screen (grants access to the
   scopes configured above)
6. Save -- the credential is now reusable across every node/workflow in
   this n8n instance

![alt text](image-5.png)

------------------------------------------------------------------------

# 2. Alternative: Service Account (No Login Flow)

Useful for headless/server deployments where no human is available to
click through an OAuth consent screen.

1. **APIs & Services** → **Credentials** → **Create Credentials** →
   **Service account**
2. Name it, create, then open it → **Keys** tab → **Add Key** → **JSON**
   -- downloads a private key file
3. Enable the same APIs as Section 1.2 (Sheets + Drive)
4. **Share the target spreadsheet** with the service account's email
   address (looks like `name@project-id.iam.gserviceaccount.com`) --
   give it Editor access, same as sharing with a person
5. In n8n: Google Sheets node → Credential → **Create New** → **Google
   Sheets Service Account**. Paste the service account email and
   private key from the downloaded JSON

**Trade-off**: Service Account skips the login flow entirely (good for
automation/servers) but requires manually sharing every sheet with the
service account email, and can't act "as you" for sheets you haven't
explicitly shared.

------------------------------------------------------------------------

# 3. Node Overview

The Google Sheets integration in n8n has two parts:

-   **Google Sheets node** -- performs an operation (read, write,
    update, etc.) when the workflow reaches it
-   **Google Sheets Trigger node** -- starts a workflow when a sheet
    changes (used in this project for both `Google form responses` and
    `Extract data from updated sheet`)

------------------------------------------------------------------------

# 4. Google Sheets Trigger -- Parameters

| Parameter | Description |
|---|---|
| **Credential** | Which OAuth2/Service Account credential to use |
| **Document** | Select spreadsheet by URL, ID, or from list (Drive picker) |
| **Sheet** | Which tab/sheet within the spreadsheet |
| **Trigger On** | `Row Added` or `Row Updated` |
| **Poll Times** | How often n8n checks for changes (e.g. every minute) |
| **Options → Include in Output** | Whether to return the full row or only changed fields |

```text
Example (from your workflow):
Document: PCE Workshop Registrations
Sheet: Form Responses
Trigger On: Row Added
Poll: Every 1 minute
→ fires "Google form responses" trigger node
```

```text
Example (Notification Dispatch trigger):
Trigger On: Row Added
Sheet: Registrations (same sheet, downstream of Workflow 1's writes)
→ fires "Extract data from updated sheet"
```

**Note**: `Row Updated` triggers can fire multiple times if a row is
edited more than once -- pair with a status field (like your
`email_status`) to avoid reprocessing.

![alt text](image-2.png)

------------------------------------------------------------------------

# 5. Google Sheets Node -- All Operations

Selected via the **Resource** (`Sheet Within Document` / `Spreadsheet`)
and **Operation** dropdowns.

## 5.1 Resource: Sheet Within Document

| Operation | What it does |
|---|---|
| **Append** | Adds new row(s) to the end of the sheet |
| **Append or Update** | Adds a new row, or updates an existing one if a matching key is found (upsert) |
| **Clear** | Wipes cell contents in a range without deleting the sheet/rows |
| **Delete Rows or Columns** | Removes specific rows/columns entirely |
| **Get Row(s)** | Reads data -- returns rows matching filters, or all rows |
| **Update Row** | Overwrites specific row(s) matched by row number or key column |
| **Remove Sheet** | Deletes an entire tab from the spreadsheet |

## 5.2 Resource: Spreadsheet

| Operation | What it does |
|---|---|
| **Create** | Creates a brand-new Google Sheets spreadsheet |

------------------------------------------------------------------------

# 6. Key Operations Used in This Project

## 6.1 Get Row(s) in Sheet

Used by **"Get row(s) in sheet"** to fetch existing rows and compute the
next row number before generating a Registration ID.

| Parameter | Notes |
|---|---|
| Document / Sheet | Target spreadsheet + tab |
| Filters | Optional -- match rows by column value |
| Return All | On = all matching rows; Off = limit to N results |
| Combine Filters | AND / OR, if multiple filters used |

![alt text](AUTOMATION-LAB/assests/screenshots/image-3.png)

## 6.2 Update Row

Used by **"update reg ID and QR code"**, **"Finalise sheet"**, **"set
reg status to invalid"**, and **"update email_status"**.

| Parameter | Notes |
|---|---|
| Document / Sheet | Target spreadsheet + tab |
| Matching Column | The column used to find the row to update (e.g. row number, email, or a unique ID) |
| Values to Send | Which columns to overwrite, and with what values (often expressions, e.g. `{{ $json.registrationId }}`) |
| Value Input Mode | `USER_ENTERED` (interprets formulas/formatting like manual typing) vs `RAW` (stores exactly as given) |

```text
Example: update email_status
Matching Column: row_number
Values to Send: email_status = "Sent"
```
![alt text](image-4.png)

## 6.3 Append

Not explicitly named in your screenshots, but relevant if you ever add
brand-new rows programmatically (vs. relying on the Form's own append
behavior).

| Parameter | Notes |
|---|---|
| Document / Sheet | Target spreadsheet + tab |
| Mapping Mode | **Auto-map Input Data** (matches by column header name) or **Map Each Column Manually** |
| Options → Cell Format | How data types are written (e.g. dates as strings vs. sheet-native dates) |

------------------------------------------------------------------------

# 7. Common Settings & Options (All Operations)

| Setting | Description |
|---|---|
| **Document** | Can be selected From List, By URL, or By ID |
| **Sheet** | Can be selected From List, By Name, or By ID (gid) |
| **Value Input Mode** | `RAW` vs `USER_ENTERED` -- affects whether formulas/auto-formatting apply |
| **Value Render Mode** *(read ops)* | `FORMATTED_VALUE`, `UNFORMATTED_VALUE`, or `FORMULA` -- controls what "Get Row(s)" returns for formula cells |
| **Data Location** *(read ops)* | Whether the first row is treated as headers |
| **Range** | A1-notation range to restrict the operation (e.g. `A1:F50`) |
| **Continue On Fail** | Lets the workflow proceed even if this node errors (routes to error output if enabled) |

------------------------------------------------------------------------

# 8. Data Mapping With Google Sheets

-   **Column headers become JSON keys.** A sheet with headers
    `row_number`, `Email Address`, `email_status` outputs items shaped
    like:

```json
{
  "row_number": 0,
  "Email Address": "aartikhandelwal1711@gmail.com",
  "email_status": "Sent"
}
```

-   Reference these fields anywhere downstream using expressions:
    `{{ $json["Email Address"] }}`
-   When **Update Row** needs a "Matching Column," it must be a value
    that uniquely identifies the row (row number is simplest and most
    reliable; avoid matching on fields that could contain duplicates,
    like names).

------------------------------------------------------------------------

# 9. Testing & Debugging Google Sheets Nodes

-   **Pin Data** on a Get Row(s) node while building downstream logic,
    so you're not re-reading the live sheet on every test run.
-   **Rate limits**: Google Sheets API allows a limited number of
    read/write requests per minute per project. If you see `429` /
    `RATE_LIMIT_EXCEEDED` errors, add a **Wait** node or reduce polling
    frequency on the Trigger.
-   **Auth errors (`401`/`403`)**: usually an expired OAuth2 token
    (n8n auto-refreshes in most cases) or the sheet not being shared
    with a Service Account's email.
-   **Wrong sheet/tab**: double-check the **Sheet** parameter -- it's
    easy to point at "Sheet1" when your data lives in a renamed tab.

------------------------------------------------------------------------

# Quick Reference Cheat Sheet

| Task | Operation |
|---|---|
| Start a workflow on new form response | Google Sheets Trigger, "Row Added" |
| Read existing rows | Get Row(s) |
| Add a brand-new row | Append |
| Add or update depending on existence | Append or Update |
| Overwrite specific row(s) | Update Row |
| Wipe cell contents, keep structure | Clear |
| Remove rows/columns entirely | Delete Rows or Columns |
| Delete a whole tab | Remove Sheet |
| Create a new spreadsheet | Create (Spreadsheet resource) |

------------------------------------------------------------------------

