#!/usr/bin/env bash

# This script is used to generate the getting-started.json configuration file
# used in the Getting Started quickstart guide on the docs site. Avoids the
# need to have the getting-started.json committed to the repo since it's an
# invalid JSON file when not filled in, which is annoying.

reqenv() {
    if [ -z "${!1}" ]; then
        echo "Error: environment variable '$1' is undefined"
        exit 1
    fi
}

# Check required environment variables
reqenv "GS_ADMIN_ADDRESS"
reqenv "GS_BATCHER_ADDRESS"
reqenv "GS_PROPOSER_ADDRESS"
reqenv "GS_SEQUENCER_ADDRESS"
reqenv "L1_RPC_URL"

# Get the finalized block timestamp and hash
block=$(cast block  --rpc-url "$L1_RPC_URL")
timestamp=$(echo "$block" | awk '/timestamp/ { print $2 }')
blockhash=$(echo "$block" | awk '/hash/ { print $2 }')

# Generate the config file
config=$(cat << EOL
{
  "l1StartingBlockTag": "$blockhash",
  "l1ChainID": 8899,
  "l2ChainID": 7003,
  "l2BlockTime": 2,
  "l1BlockTime": 12,
  "maxSequencerDrift": 600,
  "sequencerWindowSize": 3600,
  "channelTimeout": 300,
  "p2pSequencerAddress": "$GS_SEQUENCER_ADDRESS",
  "batchInboxAddress": "0xff00000000000000000000000000000000007003",
  "batchSenderAddress": "$GS_BATCHER_ADDRESS",
  "l2OutputOracleSubmissionInterval": 1800,
  "l2OutputOracleStartingBlockNumber": 0,
  "l2OutputOracleStartingTimestamp": $timestamp,
  "l2OutputOracleProposer": "$GS_PROPOSER_ADDRESS",
  "l2OutputOracleChallenger": "0xd9235915152E66c07da859823A944Fb6DDfE91AE",
  "l2GenesisBlockBaseFeePerGas": "0x3b9aca00",
  "l2GenesisBlockGasLimit": "0xBEBC200",
  "l2GenesisRegolithTimeOffset": "0x0",
  "l2GenesisDeltaTimeOffset": "0x0",
  "l2GenesisCanyonTimeOffset": "0x0",
  "L2GenesisEcotoneTimeOffset": "0x0",
  "L2GenesisFjordTimeOffset": "0x0",
  "gasPriceOracleOverhead": 2100,
  "gasPriceOracleScalar": 1000000,
  "gasPriceOracleBaseFeeScalar": 1368,
  "gasPriceOracleBlobBaseFeeScalar": 810949,
  "proxyAdminOwner": "0xd9235915152E66c07da859823A944Fb6DDfE91AE",
  "baseFeeVaultRecipient": "0xd9235915152E66c07da859823A944Fb6DDfE91AE",
  "l1FeeVaultRecipient": "0xd9235915152E66c07da859823A944Fb6DDfE91AE",
  "sequencerFeeVaultRecipient": "0xd9235915152E66c07da859823A944Fb6DDfE91AE",
  "finalSystemOwner": "0xd9235915152E66c07da859823A944Fb6DDfE91AE",
  "superchainConfigGuardian": "0xd9235915152E66c07da859823A944Fb6DDfE91AE",
  "baseFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "l1FeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "sequencerFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "baseFeeVaultWithdrawalNetwork": 0,
  "l1FeeVaultWithdrawalNetwork": 0,
  "sequencerFeeVaultWithdrawalNetwork": 0,
  "enableGovernance": false,
  "governanceTokenName": "Optimism",
  "governanceTokenSymbol": "OP",
  "governanceTokenOwner": "0xd9235915152E66c07da859823A944Fb6DDfE91AE",
  "finalizationPeriodSeconds": 300,
  "eip1559Denominator": 50,
  "eip1559Elasticity": 6,
  "eip1559DenominatorCanyon": 250,
  "l2GenesisRegolithTimeOffset": "0x0",
  "systemConfigStartBlock": 0,
  "requiredProtocolVersion": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "recommendedProtocolVersion": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "faultGameAbsolutePrestate": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "faultGameMaxDepth": 8,
  "faultGameClockExtension": 0,
  "faultGameMaxClockDuration": 1200,
  "faultGameGenesisBlock": 0,
  "faultGameGenesisOutputRoot": "0xDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF",
  "faultGameSplitDepth": 4,
  "faultGameWithdrawalDelay": 604800,
  "preimageOracleMinProposalSize": 10000,
  "preimageOracleChallengePeriod": 120,
  "proofMaturityDelaySeconds": 12,
  "disputeGameFinalityDelaySeconds": 6,
  "respectedGameType": 0,
  "useFaultProofs": false,
  "fundDevAccounts": false,
  "usePlasma": false,
  "daChallengeWindow": 160,
  "daResolveWindow": 160,
  "daBondSize": 1000000,
  "useCustomGasToken": true,
  "customGasTokenAddress": "0x99999995641f09cFD8AE4469Fa2aF8cF6c12C33F"
}
EOL
)
#0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
#0x39BE211eAb65e05ba98af949d3e16F7A1683d94E
# Write the config file
echo "$config" > ../packages/contracts-bedrock/deploy-config/pom.json
