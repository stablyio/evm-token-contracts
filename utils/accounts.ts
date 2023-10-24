export function getMnemonic(networkName: string): string {
  const mnemonicKey = "MNEMONIC_" + networkName.toUpperCase();
  const mnemonic = process.env[mnemonicKey];
  if (mnemonic && mnemonic !== "") {
    return mnemonic;
  }
  // Return empty if no mnemonic is found, since we may not be using this mnemonic
  console.log(".env value was empty for: " + mnemonicKey);
  return "";
}
