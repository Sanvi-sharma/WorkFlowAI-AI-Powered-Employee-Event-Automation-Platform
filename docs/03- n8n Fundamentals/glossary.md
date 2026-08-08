                    Google Form
                         │
                         ▼
              WORKFLOW 1 - Registration
                         │
        Normalize → Validate → Generate ID
                         │
          Generate Metadata → Update Sheet
                         │
      registration_status = Registered
      email_status = Pending
      whatsapp_status = Pending
                         │
                         ▼
                 Google Sheet Updated
                         │
──────────────────────────────────────────────────
                         │ (row updated trigger)
                         ▼
             WORKFLOW 2 - Communication
                         │
       Check registration_id exists?
                         │
      Check email_status == Pending?
                         │
            Send Email
                         │
      Update email_status = Sent
                         │
      Check whatsapp_status == Pending?
                         │
          Send WhatsApp
                         │
    Update whatsapp_status = Sent




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Workshop Registration Confirmation</title>
</head>

<body style="margin:0;padding:0;background-color:#f4f7fb;font-family:Arial,Helvetica,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f7fb;padding:30px 0;">
<tr>
<td align="center">

<table width="650" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:10px;overflow:hidden;box-shadow:0 3px 10px rgba(0,0,0,0.08);">

<tr>
<td style="background:#0F172A;padding:30px;text-align:center;color:#ffffff;">
<h1 style="margin:0;font-size:28px;">PrimathixAi AI Experience Series</h1>
<p style="margin-top:10px;font-size:16px;">
Vol. 02 • Unlock the Power of Data with Machine Learning
</p>
</td>
</tr>

<tr>
<td style="padding:35px;">

<p style="font-size:16px;">
Dear <strong>{{ $json["student_name"]}}</strong>,
</p>

<p style="font-size:16px;">
Thank you for registering for
<strong>PrimathixAi AI Experience Series – Vol. 02: Unlock the Power of Data with Machine Learning!</strong> 🎉
</p>

<p style="font-size:16px;">
Your registration has been successfully received, and we're excited to have you join us for a day of learning, innovation, and hands-on exploration into the world of Machine Learning.
</p>

<hr style="border:none;border-top:1px solid #eeeeee;margin:30px 0;">

<h2 style="color:#2563EB;">📅 Workshop Details</h2>

<table cellpadding="8" cellspacing="0" style="font-size:15px;">

<tr>
<td><strong>Event</strong></td>
<td>PrimathixAi AI Experience Series – Vol. 02: Unlock the Power of Data with Machine Learning</td>
</tr>

<tr>
<td><strong>Date</strong></td>
<td>Saturday, 25 July 2026</td>
</tr>

<tr>
<td><strong>Time</strong></td>
<td>10:00 AM – 4:00 PM (IST)</td>
</tr>

</table>

<br>

<h2 style="color:#2563EB;">🚀 What You'll Experience</h2>

<ul style="line-height:1.9;font-size:15px;">
<li>🤖 Introduction to Machine Learning & AI</li>
<li>📊 Hands-on project-based learning</li>
<li>💡 Real-world applications of Data Science</li>
<li>🎯 Interactive activities & team challenges</li>
<li>🗣️ Communication & Personality Development Session</li>
<li>🚀 Career Insights & Guidance</li>
<li>🏅 Certificate of Participation</li>
</ul>

<hr style="border:none;border-top:1px solid #eeeeee;margin:30px 0;">

<h2 style="color:#2563EB;">📝 Your Registration Details</h2>

<table cellpadding="10" cellspacing="0" width="100%" style="border-collapse:collapse;border:1px solid #dddddd;">

<tr style="background:#f7f9fc;">
<td><strong>Registration ID</strong></td>
<td>{{ $json["Registration ID"] }}</td>
</tr>

<tr>
<td><strong>Name</strong></td>
<td>{{ $json["Full Name"] }}</td>
</tr>

<tr style="background:#f7f9fc;">
<td><strong>Email</strong></td>
<td>{{ $json["Email Address as their response"] }}</td>
</tr>

</table>

<br>

<p style="font-size:15px;">
Please save your <strong>Registration ID</strong>, as it may be required for workshop-related communication and verification.
</p>

<p style="font-size:15px;">
Further updates, joining instructions, and important announcements will be shared with you before the event.
</p>

<p style="font-size:15px;">
If you have any questions, simply reply to this email—we'll be happy to assist you.
</p>

<p style="font-size:15px;">
We look forward to welcoming you on <strong>25 July 2026</strong> for another exciting edition of the PrimathixAi AI Experience Series.
</p>

<h2 style="text-align:center;color:#2563EB;">
See you soon! 🚀
</h2>

<br>

<p style="font-size:15px;">
Warm Regards,<br><br>

<strong>Team PrimathixAi</strong><br>
PrimathixAi Technologies Pvt. Ltd.<br>
<i>Engineering Future-Ready Professionals</i>
</p>

</td>
</tr>

<tr>
<td style="background:#0F172A;color:#ffffff;text-align:center;padding:18px;font-size:13px;">
© 2026 PrimathixAi Technologies Pvt. Ltd. All Rights Reserved.
</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>