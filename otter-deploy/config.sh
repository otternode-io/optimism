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
  "l1ChainID": 88991,
  "l2ChainID": 7002,
  "l2BlockTime": 2,
  "l1BlockTime": 12,
  "maxSequencerDrift": 600,
  "sequencerWindowSize": 3600,
  "channelTimeout": 60,
  "p2pSequencerAddress": "$GS_SEQUENCER_ADDRESS",
  "batchInboxAddress": "0xff00000000000000000000000000000000042071",
  "batchSenderAddress": "$GS_BATCHER_ADDRESS",
  "l2OutputOracleSubmissionInterval": 120,
  "l2OutputOracleStartingBlockNumber": 1,
  "gasPriceOracleOverhead": 2100,
  "gasPriceOracleScalar": 1000000,
  "gasPriceOracleBaseFeeScalar": 1368,
  "gasPriceOracleBlobBaseFeeScalar": 810949,

  "l2OutputOracleStartingTimestamp": $timestamp,

  "l2OutputOracleProposer": "$GS_PROPOSER_ADDRESS",
  "l2OutputOracleChallenger": "$GS_ADMIN_ADDRESS",

  "l2GenesisBlockBaseFeePerGas": "0x3B9ACA00",
  "l2GenesisBlockGasLimit": "0x17D7840",
  "proxyAdminOwner": "$GS_ADMIN_ADDRESS",
  "baseFeeVaultRecipient": "$GS_ADMIN_ADDRESS",
  "l1FeeVaultRecipient": "$GS_ADMIN_ADDRESS",
  "sequencerFeeVaultRecipient": "$GS_ADMIN_ADDRESS",
  "finalSystemOwner": "$GS_ADMIN_ADDRESS",
  "superchainConfigGuardian": "$GS_ADMIN_ADDRESS",


  "baseFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "l1FeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "sequencerFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "baseFeeVaultWithdrawalNetwork": 0,
  "l1FeeVaultWithdrawalNetwork": 0,
  "sequencerFeeVaultWithdrawalNetwork": 0,
  "enableGovernance": true,
  "governanceTokenName": "Optimism",
  "governanceTokenSymbol": "OP",
  "governanceTokenOwner": "$GS_ADMIN_ADDRESS",
  "finalizationPeriodSeconds": 15,
  "eip1559Denominator": 50,
  "eip1559DenominatorCanyon": 250,
  "eip1559Elasticity": 10,
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
  "usePlasma": true,
  "daChallengeWindow": 100,
  "daResolveWindow": 100,
  "daBondSize": 1000,
  "daResolverRefundPercentage": 50,
  "useCustomGasToken": true,
  "customGasTokenAddress": "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"
}
EOL
)
#0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
#0x39BE211eAb65e05ba98af949d3e16F7A1683d94E
# Write the config file
echo "$config" > ../packages/contracts-bedrock/deploy-config/otter.json
