CREATE DATABASE IF NOT EXISTS MARKETING_ASSIGNMENT;

CREATE SCHEMA IF NOT EXISTS MARKETING_ASSIGNMENT.RAW;

CREATE SCHEMA IF NOT EXISTS MARKETING_ASSIGNMENT.ANALYTICS;
ASSIGNMENT_MARKETING

SHOW TABLES IN MARKETING_ASSIGNMENT.RAW;
DESCRIBE TABLE MARKETING_ASSIGNMENT.RAW.FACEBOOK;
DESCRIBE TABLE MARKETING_ASSIGNMENT.RAW.GOOGLE;
DESCRIBE TABLE MARKETING_ASSIGNMENT.RAW.TIKTOK;

CREATE SCHEMA IF NOT EXISTS MARKETING_ASSIGNMENT.ANALYTICS;

/* Facebook preprocessing */
CREATE OR REPLACE VIEW MARKETING_ASSIGNMENT.ANALYTICS.STG_FACEBOOK AS
SELECT
  date,
  campaign_id,
  campaign_name,
  ad_set_id,
  ad_set_name,

  impressions,
  clicks,
  spend,
  conversions,

  video_views,
  engagement_rate,
  reach,
  frequency,

  /* Google-only fields */
  NULL::FLOAT  AS conversion_value,
  NULL::FLOAT  AS ctr,
  NULL::FLOAT  AS avg_cpc,
  NULL::FLOAT  AS quality_score,
  NULL::FLOAT  AS search_impression_share,

  /* TikTok-only fields */
  NULL::NUMBER AS video_watch_25,
  NULL::NUMBER AS video_watch_50,
  NULL::NUMBER AS video_watch_75,
  NULL::NUMBER AS video_watch_100,
  NULL::NUMBER AS likes,
  NULL::NUMBER AS shares,
  NULL::NUMBER AS comments
FROM MARKETING_ASSIGNMENT.RAW.FACEBOOK;


/* Google preprocessing */
CREATE OR REPLACE VIEW MARKETING_ASSIGNMENT.ANALYTICS.STG_GOOGLE AS
SELECT
  date,
  campaign_id,
  campaign_name,
  ad_group_id   AS ad_set_id,
  ad_group_name AS ad_set_name,

  impressions,
  clicks,
  cost          AS spend,
  conversions,

  /* Facebook/TikTok fields */
  NULL::NUMBER AS video_views,
  NULL::FLOAT  AS engagement_rate,
  NULL::NUMBER AS reach,
  NULL::FLOAT  AS frequency,

  /* Google-only fields */
  conversion_value,
  ctr,
  avg_cpc,
  quality_score,
  search_impression_share,

  /* TikTok-only fields */
  NULL::NUMBER AS video_watch_25,
  NULL::NUMBER AS video_watch_50,
  NULL::NUMBER AS video_watch_75,
  NULL::NUMBER AS video_watch_100,
  NULL::NUMBER AS likes,
  NULL::NUMBER AS shares,
  NULL::NUMBER AS comments
FROM MARKETING_ASSIGNMENT.RAW.GOOGLE;

/* TikTok preprocessing */
CREATE OR REPLACE VIEW MARKETING_ASSIGNMENT.ANALYTICS.STG_TIKTOK AS
SELECT
  date,
  campaign_id,
  campaign_name,
  adgroup_id   AS ad_set_id,
  adgroup_name AS ad_set_name,

  impressions,
  clicks,
  cost         AS spend,
  conversions,

  video_views,
  NULL::FLOAT  AS engagement_rate,
  NULL::NUMBER AS reach,
  NULL::FLOAT  AS frequency,

  /* Google-only fields */
  NULL::FLOAT  AS conversion_value,
  NULL::FLOAT  AS ctr,
  NULL::FLOAT  AS avg_cpc,
  NULL::FLOAT  AS quality_score,
  NULL::FLOAT  AS search_impression_share,

  /* TikTok-only fields */
  video_watch_25,
  video_watch_50,
  video_watch_75,
  video_watch_100,
  likes,
  shares,
  comments
FROM MARKETING_ASSIGNMENT.RAW.TIKTOK;


CREATE OR REPLACE TABLE MARKETING_ASSIGNMENT.ANALYTICS.UNIFIED_ADS AS
SELECT 'FACEBOOK' AS channel, * FROM MARKETING_ASSIGNMENT.ANALYTICS.STG_FACEBOOK
UNION ALL
SELECT 'GOOGLE'   AS channel, * FROM MARKETING_ASSIGNMENT.ANALYTICS.STG_GOOGLE
UNION ALL
SELECT 'TIKTOK'   AS channel, * FROM MARKETING_ASSIGNMENT.ANALYTICS.STG_TIKTOK;

/* Checking if merge tables are correct */
SELECT channel, COUNT(*) AS row_count, SUM(spend) AS total_spend
FROM MARKETING_ASSIGNMENT.ANALYTICS.UNIFIED_ADS
GROUP BY channel;

/*Looking for duplicated rows*/
SELECT
  date,
  channel,
  campaign_id,
  ad_set_id,
  COUNT(*) AS row_count
FROM MARKETING_ASSIGNMENT.ANALYTICS.UNIFIED_ADS
GROUP BY
  date,
  channel,
  campaign_id,
  ad_set_id
HAVING COUNT(*) > 1;


/*Printing and downloading final table*/
SELECT *
FROM MARKETING_ASSIGNMENT.ANALYTICS.UNIFIED_ADS;