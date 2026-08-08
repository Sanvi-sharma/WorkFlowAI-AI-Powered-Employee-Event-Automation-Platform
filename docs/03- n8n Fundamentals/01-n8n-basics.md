# n8n Fundamentals -- Core Concepts Reference

## Objective

Explain the building blocks of every n8n workflow -- triggers, nodes,
credentials, APIs, expressions, data mapping, testing, debugging,
executions, and automation logic -- with concrete examples, so this doc
can be used as a standing reference (and onboarding material for anyone
new to the project).

------------------------------------------------------------------------

# 1. Triggers

A **trigger** is the node that starts a workflow. Every workflow needs
exactly one active trigger (or more, if you're using multiple entry
points into the same workflow). Trigger nodes are always the leftmost
node on the canvas and are visually marked with a lightning bolt.

## 1.1 Manual Trigger

Starts the workflow only when you click "Execute Workflow" in the
editor. Used for building/testing, not for production automation.

```text
Example: Manual Trigger → HTTP Request → Set
(You click Execute; nothing runs on its own)
```

## 1.2 Schedule Trigger

Runs on a time-based schedule -- cron expressions or simple intervals
(every X minutes/hours/days).

```text
Example: Schedule Trigger (Cron: 0 9 * * *) → Send daily report email
Runs every day at 9:00 AM.
```

## 1.3 Webhook Trigger

Exposes a unique URL. The workflow runs whenever that URL receives an
HTTP request (GET/POST/etc.), making it the entry point for external
systems, forms, or other apps calling into n8n.

```text
Example: Webhook Trigger (POST /new-lead) → Add row to CRM sheet
A form on your website POSTs to the webhook URL when submitted.
```

## 1.4 App-Based / Polling Triggers

Node-specific triggers that watch an external app/service for
changes -- typically by polling on an interval. Examples used in this
project:

-   **Google Sheets Trigger** -- fires on `rowAdded` or `rowUpdated`
    (this is what "Google form responses" and "Extract data from
    updated sheet" use in the registration workflow).
-   **Gmail Trigger** -- fires when a new email arrives.
-   **Slack Trigger** -- fires on new messages/events in a channel.

```text
Example: Google Sheets Trigger (rowAdded) → Normalize Student Data
Fires whenever a new row appears in the linked sheet.
```

## 1.5 Error Trigger

Not a normal entry point -- it's attached to a *different* workflow and
fires when *that* workflow throws an unhandled error. Used to build
centralized error alerting.

```text
Example: Workflow A fails → Error Trigger (Workflow B) → Send Slack alert
```

## 1.6 Chat Trigger

Starts the workflow when a message is sent to an n8n-hosted chat
interface -- commonly used for AI Agent workflows.

------------------------------------------------------------------------

# 2. Nodes

A **node** is a single step in a workflow -- it receives data, does one
thing to it, and passes data to the next node. Nodes fall into a few
functional categories:

## 2.1 Trigger Nodes

Covered above -- start the workflow.

## 2.2 Action / Regular Nodes

Do something with data -- call an API, write to a database, transform a
field. Examples from this project: **Google Sheets** (read/update),
**Send an Email**, **Send message** (WhatsApp), **HTTP Request** (QR
code generation).

## 2.3 Logic / Flow-Control Nodes

Control *which path* the data takes next, without necessarily changing
the data itself.

| Node | Purpose |
|---|---|
| **IF** | Two-way branch: true / false, based on a condition |
| **Switch** | Multi-way branch: route to one of several outputs based on a value |
| **Merge** | Combine data from two or more branches back into one |
| **Filter** | Keep only items matching a condition, drop the rest |
| **Loop Over Items (Split in Batches)** | Process items in batches, one chunk at a time |
| **Wait** | Pause execution for a set time or until a webhook/condition |

```text
Example (from your workflow): Reg ID Verification (Switch)
  → branch 1: ID exists → Set reg status to invalid
  → branch 2: ID missing → Get row(s) in sheet → ... → Finalise sheet
```

## 2.4 Data Transformation Nodes

Reshape data without calling any external service.

| Node | Purpose |
|---|---|
| **Set / Edit Fields** | Add, rename, or overwrite fields on each item |
| **Code** | Run custom JavaScript (or Python) for complex logic |
| **Function** *(legacy)* | Predecessor to Code node |
| **Item Lists** | Sort, dedupe, aggregate, split arrays into items |
| **Date & Time** | Format/parse/calculate dates |

```text
Example (from your workflow): Generate Registration ID (Code node)
  Runs a JS snippet to build a unique ID string from row number + timestamp.
```

## 2.5 Core Utility Nodes

**NoOp** (do nothing -- useful as a visual breakpoint/label),
**Sticky Note** (canvas documentation), **Sub-workflow / Execute
Workflow** (call another workflow as a reusable step).

------------------------------------------------------------------------

# 3. Credentials

**Credentials** are how n8n securely stores the secrets a node needs to
talk to an external service -- API keys, OAuth tokens, passwords. They
are stored encrypted (via `N8N_ENCRYPTION_KEY`) and referenced by name
inside nodes; the actual secret values are never shown in the workflow
JSON export.

## 3.1 Types of Credentials

| Type | Used for | Example |
|---|---|---|
| **API Key** | Simple header/query-param auth | QR code API, most SaaS REST APIs |
| **OAuth2** | Delegated account access via login flow | Google Sheets, Gmail |
| **Basic Auth** | Username + password | Some self-hosted APIs, n8n's own login |
| **Bearer Token** | Token in `Authorization` header | Many modern REST APIs |
| **Custom / Header Auth** | Arbitrary header-based auth | Provider-specific APIs (e.g. WhatsApp) |

## 3.2 How to Set Up a Credential

1. Open any node that requires a credential (e.g. Google Sheets).
2. Click the **Credential** dropdown → **Create New Credential**.
3. Choose the auth type (n8n usually pre-selects the right one for that
   node).
4. Fill in the required fields:
   -   OAuth2: click **Connect my account**, complete the provider's
       login/consent screen.
   -   API Key: paste the key from the provider's dashboard.
5. Click **Save**. The credential is now reusable across any node/
   workflow in this n8n instance.

```text
Example: Google Sheets node → Credential → "Create New" → OAuth2 →
Sign in with Google → Grant Sheets access → Save as "Automation-Lab Google"
```

## 3.3 Credential Hygiene

-   Never paste real API keys into `.env.example` or commit them to git.
-   Rotate keys if a workflow JSON with embedded credential IDs is ever
    shared publicly (IDs aren't secrets, but treat them as sensitive).
-   Use separate credentials per environment (dev vs. production) where
    possible.

------------------------------------------------------------------------

# 4. APIs

Most non-trivial workflows call an external API at some point -- either
through a dedicated app node (Google Sheets, Gmail) or the generic
**HTTP Request** node for services without a built-in n8n integration.

## 4.1 HTTP Request Node -- the Universal Connector

Configure:

-   **Method**: GET, POST, PUT, PATCH, DELETE
-   **URL**: endpoint, can include expressions (see Section 5)
-   **Authentication**: none / predefined credential / generic (header,
    query, basic)
-   **Body**: JSON, form-data, or raw, depending on the API
-   **Headers**: content-type, custom headers required by the provider

```text
Example (from your workflow): Generate QR Code (HTTP Request)
  GET https://api.qrserver.com/v1/create-qr-code/?data={{ $json.registrationId }}
```

## 4.2 REST Basics Relevant to n8n

-   **GET** -- retrieve data (safe, no side effects)
-   **POST** -- create something new
-   **PUT/PATCH** -- update existing data
-   **DELETE** -- remove data
-   **Status codes** -- 2xx success, 4xx client error (bad request/auth),
    5xx server error. n8n's HTTP Request node throws an error on
    non-2xx by default (configurable).

## 4.3 Rate Limits & Retries

Many APIs (QR generation, WhatsApp, email providers) enforce rate
limits. In the HTTP Request node, enable **Retry on Fail** with a
backoff delay to handle transient failures gracefully.

------------------------------------------------------------------------

# 5. Expressions (`{{ }}`)

Expressions let you insert dynamic values into any node field instead
of hardcoding static text. Anything inside double curly braces is
evaluated as JavaScript.

## 5.1 Basic Syntax

```text
{{ $json.fieldName }}
```

Pulls `fieldName` from the current item's JSON data.

## 5.2 Common Built-in Variables

| Variable | Meaning |
|---|---|
| `$json` | The current item's data |
| `$node["Node Name"].json` | Data from a specific earlier node |
| `$input.item.json` | Same as `$json`, more explicit in Code nodes |
| `$now` | Current timestamp |
| `$today` | Current date |
| `$workflow.id` | ID of the current workflow |
| `$execution.id` | ID of the current execution |
| `$itemIndex` | Index of the current item in a batch |

## 5.3 Examples From This Project

```text
Email body:
"Hi {{ $json["First Name"] }}, your Registration ID is {{ $json.registrationId }}."

Conditional (IF node):
{{ $json.email_status }} equals "pending"

QR API URL:
https://api.qrserver.com/v1/create-qr-code/?data={{ $json.registrationId }}&size=200x200
```

## 5.4 Expressions vs. Fixed Values

Every field with an expression toggle can be switched between:

-   **Fixed** -- a static, literal value
-   **Expression** -- a dynamic value computed at runtime via `{{ }}`

------------------------------------------------------------------------

# 6. Data Mapping

n8n passes data between nodes as an **array of items**, where each item
has a `json` property (and optionally `binary` for files). Understanding
this shape is the single most useful thing for debugging weird
behavior.

## 6.1 Item Structure

```json
[
  {
    "json": {
      "row_number": 0,
      "Email Address": "aartikhandelwal1711@gmail.com",
      "email_status": "Sent"
    }
  }
]
```

## 6.2 Mapping Between Nodes

-   Drag a field from the **Input** panel of a node directly into a
    field to auto-insert the correct expression.
-   Every node, by default, receives *all items* output by the node(s)
    connected to it and runs once per item (unless configured to
    "Execute Once").
-   Use the **Merge** node when you need to combine fields from two
    different branches into a single item (e.g. matching by row number).

## 6.3 Renaming / Reshaping Data

The **Set / Edit Fields** node is the primary tool for reshaping data
before it reaches the next node -- e.g. "Normalize Student Data" in your
workflow standardizes raw Google Form field names into consistent keys
before validation.

------------------------------------------------------------------------

# 7. Testing Workflows

## 7.1 Manual Execution

Click **Execute Workflow** (or the play button on a specific node) to
run it once and inspect the output at each step without waiting for the
real trigger to fire.

## 7.2 Pin Data

Right-click a node's output → **Pin Data** to freeze a sample output.
Downstream nodes will use that pinned data on every test run instead of
re-fetching live data -- much faster iteration when building.

## 7.3 Test Webhooks

For Webhook-triggered workflows, n8n gives you a separate "Test URL"
that's only active while the editor is open and listening -- use this to
send sample requests (via curl/Postman) without affecting production
traffic.

## 7.4 Testing Individual Nodes

You can execute a single node (not the whole workflow) by clicking the
play icon on that node directly -- useful when only one step is
misbehaving.

------------------------------------------------------------------------

# 8. Debugging

## 8.1 Reading the Output Panel

Every executed node shows its output in a table/JSON view at the
bottom of the editor. Check this first -- most bugs are "the data isn't
shaped the way the next node expects."

## 8.2 Common Failure Points

-   **Expression errors** -- referencing a field that doesn't exist on
    the current item (typo, or the field only exists on a different
    node's output).
-   **Empty item list** -- an IF/Switch/Filter upstream silently
    dropped all items.
-   **Auth errors (401/403)** -- credential expired or missing scopes
    (common with Google OAuth2 after token expiry).
-   **Rate limit (429)** -- too many calls to an external API in a
    short window.

## 8.3 Debugging Tools

-   **NoOp nodes** as visual checkpoints/breakpoints on the canvas.
-   **Sticky Notes** to document known issues directly on canvas.
-   **Error Workflow** (Workflow Settings → Error Workflow) -- routes
    any unhandled failure to a separate alerting workflow.
-   **Try/Catch via node-level "Continue on Fail"** setting -- lets a
    node fail without stopping the whole execution, and routes the
    error down its own output branch for handling.

------------------------------------------------------------------------

# 9. Executions

An **execution** is one full run of a workflow, whether triggered
manually, on schedule, by webhook, or by a polling trigger.

## 9.1 Execution List

Found under the **Executions** tab (as seen in your screenshots). Shows:

-   Status: Success / Error / Waiting / Running
-   Duration
-   Trigger source
-   Timestamp

## 9.2 Inspecting Past Executions

Click any execution to see the exact data that flowed through every
node at that point in time -- critical for diagnosing "it worked
yesterday, why not today."

## 9.3 Retry Failed Executions

From the execution detail view, you can retry a failed execution
(either with original data, or re-fetching fresh data), without
re-triggering the entire chain manually.

## 9.4 Execution Data Retention

Self-hosted n8n lets you configure how long execution data is kept
(`EXECUTIONS_DATA_MAX_AGE`, etc.) -- important for disk usage on
long-running instances.

------------------------------------------------------------------------

# 10. Automation Logic

Putting it all together -- the patterns used to build real workflows
like the ones in this project.

## 10.1 Branching

**IF** for binary decisions, **Switch** for 3+ outcomes. Always name
your branch outputs clearly (n8n lets you label Switch outputs) so the
canvas is self-documenting.

```text
Example: email_status (Switch)
  → "pending" → Event configuration → Send an Email
  → "sent" → (skip, no action)
```

## 10.2 Idempotency (Don't Send Twice)

Notice the pattern in your Notification Dispatch workflow: after
sending, the workflow immediately **updates a status field** in the
sheet (`email_status` → "Sent"). This prevents the same row from
triggering a duplicate email/WhatsApp message on the next run.

## 10.3 Validation Before Action

**Validate Student Data (IF)** runs *before* any write operations --
catching bad data early avoids generating QR codes or sending emails
for invalid entries.

## 10.4 Looping / Batching

For workflows that need to process many rows in one execution, **Split
in Batches** processes items in controlled chunks -- important when
downstream APIs have per-request or per-minute limits.

## 10.5 Sub-workflows

For logic reused across multiple workflows (e.g. "generate a QR code"),
extract it into its own workflow and call it via **Execute Workflow**
rather than duplicating nodes.

## 10.6 Error Handling as a First-Class Path

Treat failure as a branch, not an afterthought: use "Continue on Fail"
+ an error branch, or a dedicated Error Trigger workflow, so failures
produce an alert instead of silently stalling.

------------------------------------------------------------------------

# Quick Reference Cheat Sheet

| Concept | One-liner |
|---|---|
| Trigger | Starts the workflow |
| Node | One step: read, write, transform, or branch |
| Credential | Securely stored auth for a service |
| HTTP Request | Generic node for any API without a dedicated integration |
| `{{ }}` | Insert a dynamic/computed value |
| Item | `{ json: {...}, binary?: {...} }` -- the data unit passed between nodes |
| Pin Data | Freeze sample output for faster iteration |
| Execution | One full run of a workflow, inspectable after the fact |
| IF / Switch | Branch data down different paths |
| Continue on Fail | Let a node fail without killing the whole run |

------------------------------------------------------------------------