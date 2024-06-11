# otter deply
edit ../.envrc
./config.sh
cd ..
pnpm install
pnpm build
cd packages/contracts-bedrock/

DEPLOYMENT_OUTFILE=deployments/pom.json DEPLOY_CONFIG_PATH=deploy-config/pom.json forge script scripts/Deploy.s.sol:Deploy   --broadcast --private-key $GS_ADMIN_PRIVATE_KEY  --rpc-url  $L1_RPC_URL --verifier blockscout --verifier-url https://exp-l1.jibchain.net/api --verify
CONTRACT_ADDRESSES_PATH=deployments/pom.json DEPLOY_CONFIG_PATH=deploy-config/pom.json STATE_DUMP_PATH=/data/l2-pom-alloc.json  forge script scripts/L2Genesis.s.sol:L2Genesis --sig 'runWithStateDump()' --chain-id 7003
./op-node/bin/op-node genesis l2  --l1-rpc  $L1_RPC_URL --deploy-config  packages/contracts-bedrock/deploy-config/pom.json --l2-allocs /data/l2-pom-alloc.json --l1-deployments  packages/contracts-bedrock/deployments/pom.json --outfile.l2 /data/genesis.json --outfile.rollup /data/rollup.json
cast send 0x4200000000000000000000000000000000000012 "createOptimismMintableERC20(address,string,string)" $TUTORIAL_L1_ERC20_ADDRESS "Demo Token" "DEMO" --private-key $PRIVATE_KEY --rpc-url $TUTORIAL_RPC_URL --json | jq -r '.logs[0].topics[2]' | cast parse-bytes32-address
