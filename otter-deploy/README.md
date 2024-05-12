# otter deply
edit ../.envrc
./config.sh
cd ..
pnpm install
pnpm build
cd packages/contracts-bedrock/
forge script scripts/Deploy.s.sol:Deploy --private-key $GS_ADMIN_PRIVATE_KEY --broadcast --rpc-url $L1_RPC_URL  --verifier blockscout --verifier-url https://exp.thaichain.org/api --verify
cd ../../otter-deploy/
PYTHONPATH=./ python3 ./main.py --monorepo-dir=../

cast send 0x4200000000000000000000000000000000000012 "createOptimismMintableERC20(address,string,string)" 0x110648bc41CC74229a296C77c10e48742D6Db6EE  "Test Token" "TEST" --private-key ca425275701a9c7a6cd0deb5569db758bf6604c253419a97072f7ac9da3f71ad --rpc-url https://rpc.hera.jbcha.in --json | jq -r '.logs[0].topics[2]' | cast parse-bytes32-address
