# Modules pour SQL Database et SQL Managed Instance


workload-lz/modules/sql/
├── types.bicep
├── instance-pool/
│   └── main.bicep
├── managed-instance/
│   ├── main.bicep
│   ├── database.bicep
│   ├── database-backup-short-term-retention-policy.bicep
│   ├── database-backup-long-term-retention-policy.bicep
│   ├── encryption-protector.bicep
│   ├── key.bicep
│   ├── security-alert-policy.bicep
│   └── vulnerability-assessment.bicep
└── server/
    ├── main.bicep
    ├── auditing-setting.bicep
    ├── database.bicep
    ├── database-backup-short-term-retention-policy.bicep
    ├── database-backup-long-term-retention-policy.bicep
    ├── elastic-pool.bicep
    ├── failover-group.bicep
    ├── firewall-rule.bicep
    ├── encryption-protector.bicep
    ├── key.bicep
    ├── virtual-network-rule.bicep
    ├── security-alert-policy.bicep
    └── vulnerability-assessment.bicep