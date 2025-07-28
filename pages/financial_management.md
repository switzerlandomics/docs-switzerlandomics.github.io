---
layout: default
math: mathjax
title: Financial management
nav_order: 5
---

Last update: 20250727
# Storage architecture plan

* TOC
{:toc}

---

# Financial management system overview

We maintain full transparency and auditability of our financials by storing structured raw data and programmatically generating our accounting records. Our financial system is built in R using a modern, developer-friendly workflow grounded in double-entry principles, asset classification, and reproducible reporting. This approach ensures clarity, precision, and trust in how company funds are spent and assets are tracked.

---

### 🔁 Currency conversion to CHF

All transactions are recorded in the original invoice currency and automatically converted to CHF during import. We first apply daily spot rates from the [Oanda API](https://www.oanda.com), which provide high-resolution exchange rates for USD/CHF, EUR/CHF, and GBP/CHF, but are limited to the most recent 180 days. For any dates outside this window or where daily data is unavailable (e.g. weekends or holidays), we fallback to the [Swiss National Bank’s](https://www.snb.ch) published monthly average rates, joined by currency and transaction month. This layered approach ensures each entry receives a consistent, auditable CHF value derived from reliable and official data sources, without requiring any manual adjustments.


---

### 📁 Ledger structure and data

We store all financial data as TSV files, with clear, human-readable entries and linked PDF receipts. This forms the single source of truth for our internal and external audits.

| File path                                                | Description                   |
| -------------------------------------------------------- | ----------------------------- |
| `~/so/docs/finance/2024_finance.tsv`                     | Raw transaction data for 2024 |
| `~/so/docs/finance/2025_finance.tsv`                     | Raw transaction data for 2025 |
| `receipt_file` column                                    | Path to receipt PDF           |
| Example: `openai_chatgpt/20240313_Receipt-2423-6370.pdf` | March 2024 ChatGPT invoice    |

Each row records:
`date`, `description`, `debit_account`, `credit_account`, `amount`, `currency`, `receipt_file`, `notes`.

All amounts are automatically converted to CHF using Oanda and SNB rates.

---

### 🧾 Core logic

We use a double-entry ledger model to track every transaction. Each entry records both a **debit** (what was received or incurred) and a **credit** (how it was paid), ensuring the signed sum across all accounts is always zero. Debit-side accounts represent the category of spend (e.g. equipment, services), while credit-side accounts record the payment method (e.g. debit card, equity).

Ledger entries are categorised upfront, allowing direct reporting of asset acquisitions, operating costs, and capital expenditure—independent of how a purchase was paid.

---

### 🧾 Account structure and treatment

| Account             | Type      | Treatment                                       | Example          |
| ------------------- | --------- | ----------------------------------------------- | ---------------- |
| `office_equipment`  | Asset     | Capitalised and depreciated monthly (3y)        | MacBook Pro      |
| `software_services` | Expense   | Operating cost (P\&L)                           | OpenAI, GitHub   |
| `web_domain`        | Expense   | P\&L item unless capitalised for multi-year use | GoDaddy renewal  |
| `debit_card`        | Liability | Cash outflow channel only                       | Company payments |

Depreciation is applied automatically each month using journal entries from `office_equipment` to `accumulated_depreciation_office_equipment` and `depreciation_expense`.

---

### 📊 Key financial indicators

Our system programmatically calculates and tracks core financial indicators from structured raw data. These metrics are regenerated whenever ledger files are updated, and exported as reproducible PDF outputs.

Key metrics include:

* **Account balances**: Summed by account type (asset, liability, expense) with directional signs for clarity.
* **Cumulative cash outflow**: Tracks total spend over time via company payment channels (e.g. debit card).
* **Depreciation schedule**: Monthly amortisation of tangible assets over a fixed 3-year period.
* **Net book value**: Tracks declining value of assets after depreciation.
* **Capital vs recurring spend**: Distinguishes between long-term investments and operational outflows.
* **Burn rate**: Monitors monthly spend rate across core cost centres.
* **Monthly P\&L**: Aggregates revenue (if present) and expenses to compute net income.
* **Balance sheet summary**: Current financial position summarised by asset, liability, and equity totals.

All metrics are based on ledger-side logic and can be verified against raw TSV records and source receipts. Outputs are saved in `images/finance_*.pdf` and reflect the current state of the ledger without manual edits or reclassification.

---

### 📌 Year-end reporting principles

We report based on **what was acquired or spent**, not the method of payment. For example, if CHF 1507 was paid via debit card, it is not reported as “CHF 1507 spent on debit card” but rather attributed to its actual categories: equipment, software, domain, etc.

Assets are tracked on the balance sheet and depreciated; expenses flow to the profit and loss statement. Payment methods are treated purely as outflow channels and are not used for categorisation.


