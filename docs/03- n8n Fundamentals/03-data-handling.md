# Data Normalization & Validation -- Set Node + IF Node

## Objective

Document the two nodes responsible for cleaning and gatekeeping incoming
registration data before it reaches the Registration ID / QR generation
steps: **Normalize Student Data** (Set node) and **Validate Student
Data** (IF node).

> 🔒 **Privacy note**: this doc intentionally uses placeholder data
> (`Jane Doe`, `student@example.com`, etc.) instead of real registrant
> information. Never commit real names, phone numbers, or emails from
> the live sheet into this repo.

------------------------------------------------------------------------
![alt text](image.png)
# 1. Normalize Student Data (Set Node)

## 1.1 Purpose

Takes the raw Google Form response and reshapes it into a consistent,
predictable schema -- clean field names, trimmed values, and default
status fields added -- so every downstream node can rely on the same
structure regardless of how the form was worded.

## 1.2 Output Schema

The normalized item has the following fields:

| Field | Type | Description |
|---|---|---|
| `student_name` | string | Full name of the registrant |
| `phone` | number | 10-digit contact number |
| `email` | string | Contact email address |
| `college` | string | Institution name |
| `degree` | string | Degree/program (e.g. B.Tech, BCA) |
| `branch` | string | Branch/specialization (e.g. CSE, IT) |
| `current_year` | string | Year of study, or "Graduated / working professionals" |
| `understanding` | string | Free-text response on AI understanding |
| `fear` | string | Free-text response on AI-related concerns |
| `automation_knowledge` | string | Free-text response on prior automation exposure |
| `registration_id` | string | Set later in the flow (empty/placeholder at this stage) |
| `registration_status` | string | Default: `"Registered"` |
| `email_status` | string | Default: `"Pending"` |
| `whatsapp_status` | string | Default: `"Pending"` |
| `reminder1_status` | string | Default: `"Pending"` |
| `reminder2_status` | string | Default: `"Pending"` |
| `attendance` | string | Default: `"Not Marked"` |
| `certificate_status` | string | Default: `"Not Sent"` |
| `feedback_form_status` | string | Default: `"Pending"` |

## 1.3 Example (Placeholder Data)

```json
{
  "student_name": "Jane Doe",
  "phone": 9999999999,
  "email": "student@example.com",
  "college": "Example Institute of Technology",
  "degree": "B.Tech",
  "branch": "CSE",
  "current_year": "1st year",
  "understanding": "I know AI is changing things, but I'm not sure how it affects my specific career.",
  "fear": "Worried automation could affect job prospects in my field.",
  "automation_knowledge": "Heard about it but haven't used it yet.",
  "registration_id": "",
  "registration_status": "Registered",
  "email_status": "Pending",
  "whatsapp_status": "Pending",
  "reminder1_status": "Pending",
  "reminder2_status": "Pending",
  "attendance": "Not Marked",
  "certificate_status": "Not Sent",
  "feedback_form_status": "Pending"
}
```

## 1.4 Set Node Notes

-   Watch for **trailing spaces in field names** -- e.g. a header of
    `"college "` (with a trailing space) instead of `"college"` will
    silently break any downstream expression referencing `$json.college`.
    Trim field names as part of normalization, not just values.
-   **"Convert types where required"** toggle (also present on the IF
    node, see below) coerces string-like numbers into actual numbers
    where the schema expects it -- relevant for `phone`, which should be
    stored/compared as a number, not a string.

------------------------------------------------------------------------

# 2. Validate Student Data (IF Node)

## 2.1 Purpose

Gatekeeps bad or malformed entries before they reach registration ID
generation, QR code creation, and sheet writes. All conditions are
joined with **AND** -- every single one must pass for the item to be
treated as valid.

## 2.2 Conditions Configured

| Field | Operator | Regex | What it enforces |
|---|---|---|---|
| `email` | matches regex | `^[^\s@]+@[^\s@]+\.[^\s@]+$` | Basic email shape: something@something.something, no spaces |
| `student_name` | matches regex | `^[A-Za-z][A-Za-z\s.'-]{1,49}$` | Starts with a letter, only letters/spaces/`.`/`'`/`-`, 2-50 chars total |
| `college` | matches regex | `^[A-Za-z][A-Za-z\s.'-]{1,49}$` | Same shape rule as name -- letters, spaces, and a few punctuation marks only |
| `branch` | matches regex | `^[A-Za-z][A-Za-z\s.'-]{1,49}$` | Same shape rule -- rejects numbers/symbols in branch name |
| `phone` | matches regex | `^[6-9]\d{9}$` | Valid Indian mobile number: starts with 6-9, exactly 10 digits total |

All five combined with `AND`:

```text
email matches email regex
  AND student_name matches name regex
  AND college matches name regex
  AND branch matches name regex
  AND phone matches phone regex
```

## 2.3 Node Behavior

-   **True branch**: item passes all conditions → proceeds to
    "Reg ID Verification" (Switch) → Registration ID / QR generation
    path.
-   **False branch**: item fails one or more conditions → route to a
    rejection/invalid path (e.g. flagging `registration_status` as
    invalid, or notifying for manual review -- confirm this branch is
    wired somewhere in your canvas so failed entries aren't silently
    dropped).
-   **"Convert types where required"** (green toggle, on by default):
    ensures fields like `phone` are compared as their proper type
    before the regex is applied, avoiding false negatives from type
    mismatches.

## 2.4 Example: Why an Item Might Fail

| Scenario | Field | Regex it fails |
|---|---|---|
| Landline or invalid mobile number | `phone` | `^[6-9]\d{9}$` -- doesn't start with 6-9, or isn't 10 digits |
| Name with a number in it (typo/test data) | `student_name` | `^[A-Za-z][A-Za-z\s.'-]{1,49}$` |
| College field left blank or contains only symbols | `college` | Same name-shape regex |
| Email missing `@` or domain | `email` | Email regex |
| Branch abbreviation with digits (e.g. `CS3`) | `branch` | Name-shape regex |

![alt text](image-1.png)

------------------------------------------------------------------------

# 3. Testing These Nodes

-   Use **Pin Data** on "Normalize Student Data" with a placeholder item
    (like the example in Section 1.3) so you're not re-submitting the
    real Google Form every time you tweak the validation regex.
-   Test edge cases deliberately: a 9-digit phone number, a name with a
    digit, an email without a domain -- confirm each correctly routes to
    the false branch.
-   If "No output data" appears on the true branch during testing, it
    means the pinned/test item failed at least one condition -- check
    each regex individually rather than assuming the whole node is
    broken.

------------------------------------------------------------------------
