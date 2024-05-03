# otter deply
edit ../.envrc
./config.sh
cd ..
pnpm install
pnpm build
cd ../packages/contracts-bedrock/
forge script scripts/Deploy.s.sol:Deploy --private-key $GS_ADMIN_PRIVATE_KEY --broadcast --rpc-url $L1_RPC_URL  --verifier blockscout --verifier-url https://exp.thaichain.org/api --verify
cd ../../otter-deploy/
PYTHONPATH=./ python3 ./main.py --monorepo-dir=../


