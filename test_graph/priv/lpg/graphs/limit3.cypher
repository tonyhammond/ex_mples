CREATE (:`Resource`:`UNIQUE IMPORT LABEL` {`uri`:"http://nobelprize.org/nobel_prizes/physics/laureates/2011/riess-bio.html", `UNIQUE IMPORT ID`:14553});
CREATE (:`Resource`:`UNIQUE IMPORT LABEL` {`uri`:"http://nobelprize.org/nobel_prizes/economic-sciences/laureates/2013/announcement.html", `UNIQUE IMPORT ID`:23446});
CREATE (:`Resource`:`UNIQUE IMPORT LABEL` {`uri`:"http://nobelprize.org/nobel_prizes/chemistry/laureates/2005/announcement.html", `UNIQUE IMPORT ID`:23447});
CREATE INDEX ON :`Resource`(`uri`);
CREATE CONSTRAINT ON (node:`UNIQUE IMPORT LABEL`) ASSERT (node.`UNIQUE IMPORT ID`) IS UNIQUE;
MATCH (n:`UNIQUE IMPORT LABEL`)  WITH n LIMIT 20000 REMOVE n:`UNIQUE IMPORT LABEL` REMOVE n.`UNIQUE IMPORT ID`;
DROP CONSTRAINT ON (node:`UNIQUE IMPORT LABEL`) ASSERT (node.`UNIQUE IMPORT ID`) IS UNIQUE;
