# Twitter Data Collection and Normalization System

A comprehensive system for crawling Twitter user data and normalizing it for analysis, with a focus on IT professionals and Japanese users.

## Database information

- `accounts`: Twitter accounts to crawl
- `cookies`: Stored cookies for each account
- `api_usage`: API usage for each account
- `person_raw`: Raw Twitter data
- `person_normalized`: Normalized Twitter data

## Project Structure

```
twitter/
├── twitter_crawler/        # Twitter data collection
│   ├── main.py            # Main crawler implementation
│   ├── twitter_batch.py   # Batch processing service
│   ├── db/                # Database management
│   └── utils/             # Utility functions
└── normalize_twitter/      # Data normalization
    ├── twitter.py          # Twitter data normalization
    ├── upsert_master.py   # Data upsert production
    └── schema/            # Database schemas
```

## Data Pipeline

### 1. Data Collection (twitter_crawler/)
- Collects raw Twitter data using Playwright, Twikit
- Stores initial data in `person_raw` table
- Parse data and store in `person_normalized` table

### 2. Data Processing (normalize_twitter/)
#### Stage 1: Raw Data to S3 and Normalization (twitter.py)
- Ingests raw data from `person_raw` table to S3
- Performs ETL process:
  - Extracts tech stack using OpenAI
  - Analyzes user bios and locations
  - Identifies IT professionals and Japanese users
  - Extracts URLs (LinkedIn, company website, etc.)
  - Normalizes data into `person_normalized` table

#### Stage 2: Production Data (upsert_master.py)
- Pulls qualified data from `person_normalized` table
- Filters for IT professionals and Japanese users
- Upserts filtered data into production `person` table

### Data Flow
```
person_raw table → S3 storage
         ↓
person_normalized table
         ↓
production person table
```

## Installation

1. Install dependencies:
```bash
poetry install
```

2. Set up environment variables:
```bash
cp .env.example .env
```

Required environment variables:
- Database credentials
- Twitter account credentials

3. Add account to crawl:
```bash
python twitter_crawler/db/manage_accounts.py add --table-name accounts --email [email] --password [password] --totp-secret [totp_secret]
```

# Note: You must run crawler first to add api types to the database (api_usage table).

## Usage

### Running the Crawler

```bash
python twitter_crawler/main.py [Args]
```

Args:
- `--raw-table-path`: Path to raw data table
- `--job-queue`: Job queue configuration
- `--job-definition`: Job definition parameters
- `--hours`: Number of hours to crawl 

### Running Data Normalization

```bash
python normalize_twitter/twitter.py normalize [Args]
```

Args:
- `--raw-table-path`: Path to raw data table
- `--ingest-id`: Ingest ID for normalization

### Running Data Upsert

```bash
python normalize_twitter/upsert_master.py
```
