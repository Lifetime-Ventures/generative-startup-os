# What NOT to Input to Claude

**Read this before using `/sync-all` or any command that sends data to Claude.**

Claude is an external AI service operated by Anthropic. Data you send is processed on Anthropic's servers.
This file outlines what you must **never** input, and how to safely work around these constraints.

---

## ❌ Never Send to Claude

### 1. Unpublished Patent Information
- Technical details of inventions not yet filed with a patent office
- Novel synthesis routes, formulas, or processes under active IP development
- **Why**: Sending to an external service may constitute public disclosure and invalidate patent rights in some jurisdictions

### 2. Patient / Human Subject Data
- Any data containing personally identifiable health information
- Clinical trial results linked to individual participants
- **Why**: Violates HIPAA (US), GDPR (EU), and equivalent regulations in most countries

### 3. Export-Controlled Technology
- Technical details subject to US EAR (Export Administration Regulations)
- Dual-use technology that may be subject to ITAR
- Nuclear, chemical, biological, or radiological technology details
- **Why**: Sharing with a foreign-operated AI service may constitute an export violation

### 4. Third-Party Confidential Information Under NDA
- Confidential information received from investors, partners, or customers under NDA
- Unpublished research data from university collaborations
- **Why**: Violates your contractual obligations

### 5. Specific Personal Financial Data
- Individual investor names combined with investment amounts
- Bank account numbers, tax IDs, or specific financial commitments
- **Why**: Privacy and regulatory compliance

---

## ⚠️ Use With Caution (Anonymize First)

These categories can be used with Claude, but must be anonymized or abstracted first:

| Data Type | How to Anonymize |
|-----------|-----------------|
| Investor names + amounts | Use codes: "Investor A (¥X億)" |
| Customer names in CRM | Use "Customer 1", "Customer 2" |
| Specific financial figures | Use ranges: "¥100M–200M range" |
| Partner organization names under NDA | Use "Partner X (academic)" |
| Employee personal information | Use role titles only |

---

## ✅ Safe to Send

- Your own OKRs, tasks, and decisions (as long as they don't include the above)
- Meeting summaries with names of people who have consented
- Publicly available competitor information
- Technology descriptions of already-published/filed patents
- General financial metrics (runway months, burn rate ranges)
- Anonymized customer feedback and pain scores

---

## How `/sync-all` Interacts With This

`/sync-all` automatically scans Gmail, Slack, Granola, and Circleback.
Before running it, ensure:

1. **Gmail**: Emails containing NDA materials, investor term sheets with specific figures, or patient data should be archived or labeled to avoid appearing in scans
2. **Slack**: Channels containing export-controlled technical discussions should not be included in the Slack MCP scope
3. **Granola/Circleback**: Meetings recorded under NDA should be excluded from auto-sync

The `/sync-all` command will display what it found before writing to Notion — **review the summary before approving**.

---

## Legal Disclaimer

This guide provides general best practices and is **not legal advice**.
For guidance specific to your jurisdiction, technology domain, or contractual obligations, consult a qualified attorney.

Export control compliance (EAR/ITAR) in particular requires expert legal review.

---

*This file should be reviewed and updated whenever your technology domain, funding stage, or jurisdiction changes.*
