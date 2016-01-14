CREATE TABLE customerkeys
(
  sk_customerid integer NOT NULL,
  customerid integer NOT NULL,
  CONSTRAINT customerkeys_pkey PRIMARY KEY (sk_customerid)
);

CREATE TABLE brokerkeys
(
  sk_brokerid integer NOT NULL,
  brokerid integer NOT NULL,
  CONSTRAINT brokerkeys_pkey PRIMARY KEY (sk_brokerid)
);

CREATE TABLE accountkeys
(
  sk_accountid integer NOT NULL,
  accountid integer NOT NULL,
  CONSTRAINT accountkeys_pkey PRIMARY KEY (sk_accountid)
);

CREATE TABLE securitykeys
(
  sk_securityid integer NOT NULL
);

CREATE TABLE companykeys
(
  sk_companyid integer NOT NULL,
  companyid integer NOT NULL
);

CREATE TABLE tradekeys
(
  sk_tradeyid integer NOT NULL,
  tradeid integer NOT NULL
);