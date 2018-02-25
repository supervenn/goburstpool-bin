# Burstpool written in GO

## Highlights

- SSE4 + AVX2 support
- fair share system based on estimated capacity
- grpc api
- can use multiple wallets as backends using the wallet API
- can talk directly to wallet database

## Requirements

- mariadb
- go > v1.9

## Setup

1. Create database

``` shellsession
echo "create database `<dbname>`" | mysql -u <user> -p
```

2. Import schema

``` shellsession
mysql -u<user> <dbname> < schema.sql
```

4. Edit config (see config section for settings)

5. run make

``` shellsession
make
```

## Config

``` yaml
# numeric id of pool
# all miners should set their reward recipient to
# this numeric id
poolPublicId: 10282355196851764065

# secret phrase of the poolPublicId
# used for transactions
secretPhrase: "I shall never let anyone know my secrete phrase"

# the pool can talk to multiple wallets with failover
# at least one is needed for it to work
walletUrls:
    - "http://176.9.47.157:6876"

# pending for miners will increase until
# this threshold (in burst) is reached
# then payout happens
minimumPayout: 250.0 # in burst

# txFee used for transaction in burst
txFee: 1.0

# blocks after blockHeightPayoutDelay will be checked
# if they were won or not (in order to avoid forks)
blockHeightPayoutDelay: 10

# share of pool on forged blocks:
# 1.0  = 100%
# 0.01 = 1%
poolFeeShare: 0.0

# all deadlines bigger than this limit will
# be ignored
# the limit will be sent as "targetDeadline" in
# the getMiningInfo response
# in s
deadlineLimit: 10000000000

# database connection data for pool's database
db:
    user: "burstpool"
    password: "super secret password for pool"
    name: "burstpooldb"

# optional database connection data base of wallet
# if omitted the pool will directly access
# the db instead of using the wallet api where
# possible
walletDB:
    user: "burstwallet"
    password: "super secret password for wallet"
    name: "burstwalletdb"

# account where fees will be transferred to
feeAccountId: 6418289488649374107

# n blocks after miners will be removed from cache
inactiveAfterXBlocks: 10

# share of winner on block forge 1 = 100%, 0.01 = 1%
winnerShare: 1

# port on which pool listens for submitNonce and getMiningInfo requests
poolPort: 8124

# web address of pool
poolAddress: "http://127.0.0.1"

# port on which web ui is reachable
webServerPort: 8080

# all deadlines of blocks with a generation time < tMin
# will be discarded for calculating the effective capacities
# this helps miners with bigger scan time
tMin: 20

# deadlines of the last nAvg blocks with a generation time > tMin
# will be used to estimate the capacities
nAvg: 20

# until nMin confirmed deadlines a miner's historical share is 0
nMin: 1

# port for grpc address
# if ommitted api server won't start
apiPort: 7777

# requests per second until the rate limiter kicks in
# by IP and requestType
allowRequestsPerSecond: 3

# block height when poc2 validation starts
# defaults to max uint64
PoC2StartHeight: 9000000
