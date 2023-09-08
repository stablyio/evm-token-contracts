export function getMnemonic(networkName: string): string {
  const mnemonic = process.env["MNEMONIC_" + networkName.toUpperCase()];
  if (mnemonic && mnemonic !== "") {
    return mnemonic;
  }
  // Fail if no mnemonic was found
  throw new Error(
    "Please set your MNEMONIC_* in a .env file or set it as an environment variable."
  );
}
