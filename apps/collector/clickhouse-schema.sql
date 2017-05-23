CREATE TABLE IF NOT EXISTS events
(
	EventDate Date,
	EventTime DateTime,
	EventID String,
	EventType UInt8,
	SessionID String,
	UserID String,
	CustomUserID String,
	SiteID UInt32,
	Xpath String,
	Href String,
	UserAgent String,
	Referer String,
	X UInt32,
	Y UInt32
) ENGINE = MergeTree(EventDate, (EventTime, EventID, Xpath), 8192)
