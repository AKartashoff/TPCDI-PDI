# TPC-DI implementation in Pentaho Data Integration (Kettle)

An implementation of the ETL flows found in the TPC-DI documentation.

Developer: Anton Kartashov
Supervisor: Vasileios Theodorou

## Execution

### Historical Load
Historical Load is performed by **Launcher.kjb** job. It requires setting the following kettle environmental variables:
- Source directory:
	+ tpcdi.input.path
- Target database:
	+ tpcdi.dbname
	+ tpcdi.host
	+ tpcdi.password
	+ tpcdi.username

This creates the tables in the target if they didn't exist before.

Potential change of identifiers in the sources, but still resulting in the same surrogate key in the target has not been considered in the implementation.

