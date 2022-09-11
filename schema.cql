CREATE KEYSPACE IF NOT EXISTS storage WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : '1' };

CREATE TABLE IF NOT EXISTS storage.site_statistics (
      source_url text PRIMARY KEY,
      links_count counter
);

CREATE TABLE IF NOT EXISTS storage.sites (
      url text,
      source_url text,
      html text,
      last_update timestamp,
      PRIMARY KEY ((url), source_url)
);

CREATE TABLE IF NOT EXISTS storage.sites_by_meta (
      url text,
      source_url text,
      title text,
      description text,
      keywords text,
      last_update timestamp,
      PRIMARY KEY ((url), title, keywords, description)
) WITH CLUSTERING ORDER BY (title ASC, keywords ASC, description ASC);

CREATE CUSTOM INDEX IF NOT EXISTS title_index ON storage.sites_by_meta (title) 
USING 'org.apache.cassandra.index.sasi.SASIIndex' 
WITH OPTIONS = {'mode': 'CONTAINS', 'analyzer_class': 'org.apache.cassandra.index.sasi.analyzer.StandardAnalyzer', 'case_sensitive': 'true'};

CREATE CUSTOM INDEX IF NOT EXISTS description_index ON storage.sites_by_meta (description) 
USING 'org.apache.cassandra.index.sasi.SASIIndex' 
WITH OPTIONS = {'mode': 'CONTAINS', 'analyzer_class': 'org.apache.cassandra.index.sasi.analyzer.StandardAnalyzer', 'case_sensitive': 'true'};

CREATE CUSTOM INDEX IF NOT EXISTS keywords_index ON storage.sites_by_meta (keywords) 
USING 'org.apache.cassandra.index.sasi.SASIIndex' 
WITH OPTIONS = {'mode': 'CONTAINS', 'analyzer_class': 'org.apache.cassandra.index.sasi.analyzer.StandardAnalyzer', 'case_sensitive': 'true'};
