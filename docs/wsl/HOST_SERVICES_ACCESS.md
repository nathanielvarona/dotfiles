# Windows Host and WSL2 Connection

## First Enable WSL2 Localhost Mirroring

```powershell
nvim ~/.wslconfig
```

```text
[wsl2]
networkingMode=mirrored
```

## PostgreSQL

### Install PostgreSQL

```powershell
winget install PostgreSQL.PostgreSQL.18
```

### Configure PostgreSQL Listen Address and Authorization

```powershell
nvim 'C:\Program Files\PostgreSQL\18\data\postgresql.conf'
```

```text
listen_addresses = '*'
```

```powershell
nvim 'C:\Program Files\PostgreSQL\18\data\pg_hba.conf'
```

```text
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             0.0.0.0/0               md5
```

### Allow PostgreSQL connection on Windows Firewall

```powershell
New-NetFirewallRule -DisplayName "Allow WSL to PostgreSQL" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5432
```

### Test PostgreSQL Connection from WSL2

```sh
sudo apt update && sudo apt install postgresql-client -y

psql -h localhost -U postgres
```

### Install pgAdmin (Optional)

```powershell
winget install PostgreSQL.pgAdmin
```

## Redis (Memurai Distribution)

### Install Redis

```powershell
winget install Memurai.MemuraiDeveloper
```

### Configure Redis Bind Address

```powershell
nvim 'C:\Program Files\Memurai\memurai.conf'
```

```text
bind 0.0.0.0
```

### Allow Redis connection on Windows Firewall

```powershell
New-NetFirewallRule -DisplayName "Allow WSL to Redis (Memurai Distribution)" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 6379
```

### Test Redis Connection from WSL2

```sh
sudo apt update && sudo apt install redis-tools -y

redis-cli -h localhost -p 6379
```

### Install RedisInsigth (Optional)

```powershell
winget install RedisInsight.RedisInsight
```
