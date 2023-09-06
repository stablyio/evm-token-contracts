# EVM Token Contracts

Monorepo that contains our EVM token contracts. 

## History
This repository is the successor to previous Truffle based repositories including:
- https://github.com/stablyio/usds-horizen-eon
- https://github.com/stablyio/usds-arbitrum
- https://github.com/stablyio/usds-harmony
- https://github.com/stablyio/usds-ethereum
- https://github.com/stablyio/usds-vechain (kind of, not fully EVM compatible)
- https://github.com/stablyio/zusd-ethereum

Rather than taking the approach of creating a new repository and token template with each EVM chain we expand to, we instead manage all EVM tokens in one monorepo. This allows us to reuse code with a higher degree of confidence and add modular functionality through extensions rather than custom edits to copy and pasted code.
