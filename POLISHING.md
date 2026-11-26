# Retrieva polishing list

This is a checklist of what still needs work. It does not change the app. Each item says what the screen does today and what to polish.

## QR scanner for returned items

Today, QR Pickup Verification asks someone to type or paste the pickup code. The student already has a pickup QR on an approved claim.

- Add a camera scanner on the admin returned-item / pickup flow so the office can scan that QR instead of typing it.
- Use a free, lightweight scanner that runs in the browser. No paid QR service.
- If the camera is blocked, typing the code must still work.
- A successful scan should look up the same pickup record the typed code uses now, then confirm the return.

## Card and text alignment

Item cards, report rows, tables, and drawer text do not line up consistently between the client pages and the admin pages.

- Align card photos, titles, status pills, and action buttons to the same edges.
- Keep long item names and locations from colliding with buttons.
- Check the same screens on a phone-width window and on a desktop window.

## SMS for approvals and claim reminders

Settings already has a phone field and an SMS Notifications checkbox. The phone line says SMS verification is not available yet, and the checkbox can be saved even when the number is empty or unverified. Nothing sends a text.

- Add an SMS sender for two messages only: claim approved, and claim reminder (pickup reminder).
- In Settings, the SMS checkbox stays off and cannot be turned on until that account has a verified phone number.
- Verifying the number is a separate step from typing it. An unverified number does not receive texts.
- Do not send the password, the authenticator secret, or the raw pickup token in the text.

## Matching Center, optional

Matching Center is a manual suggestion list. Refresh suggestions scores Searching reports against Unclaimed found items. Confirm, No match, and Notify reporter are separate buttons.

- Decide whether Matching Center stays.
- If it is removed, lost reports should no longer depend on that screen to become Matched. See the next item.

## Lost reports: Matched and Resolved happen on their own

Today, Matched is set when someone confirms a suggestion in Matching Center. Resolved is set when a pickup is confirmed. Closed is chosen by hand in the lost-report form, and that same form can also set Matched or Resolved directly.

- Matched and Resolved should be applied by the process, not picked from the status menu.
- A lost report becomes Matched when it is linked to a found item through the real match path that remains after the Matching Center decision.
- A lost report becomes Resolved when the related pickup is confirmed and the item is returned.
- The admin lost-report form should not offer Matched or Resolved as a manual status.

## Closed is manual, and a closed report is finished

Closed must stay a choice an admin makes on purpose.

- Only an admin action can set Closed.
- A closed lost report does not appear on the public Lost Items page.
- A closed report cannot be edited, claimed, matched, or used by other actions.
- The owner can still open their own closed report to read it. They cannot change it.

## Clearer audit lines on buttons

Audit Logs records that something happened, but several button actions still store a short code such as `match=4` or `lost=12` instead of a sentence a person can read.

- Each admin button that changes a record should write a plain detail line: what was done, which item or claim, and the person's name when the action is about an account.
- Password resets already say "Password changed for user" plus the name. Keep that. Do not write the password.
- Do not write email codes, authenticator secrets, or pickup tokens into the log.

## Security role sees less than Administrator

Admin and Security currently share one sidebar and the same dashboard, including recent activity, Users, Reports & Analytics, and Audit Logs.

Security should keep the office work and lose the account and oversight tools.

- Hide Users, Reports & Analytics, and Audit Logs from the Security sidebar.
- Block those pages and their downloads if a Security account opens the address directly. Hiding the link is not enough.
- On the dashboard, hide audit rows and activity that shows what other accounts did.
- Security can still use lost reports, found items, log found item, claims, QR pickup, returned items, and their own Settings.
- Matching Center follows the decision in the Matching Center item above.

## Front end design

The client and admin shells share one layout. Tables, drawers, charts, and forms still look like separate passes.

- Use one spacing, type size, and button style on client and admin screens.
- Make the admin tables easier to scan: code, item, status, and the action on each row.
- Keep the Overview charts above Recent claims, and keep Download CSV and Download PDF only on Reports & Analytics and Audit Logs.
