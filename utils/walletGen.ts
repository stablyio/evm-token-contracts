import { Wallet } from "ethers";
import crypto from "crypto";

const privateKey: string = crypto.randomBytes(32).toString("hex");
console.log("Private Key:", privateKey);

const wallet: Wallet = new Wallet(privateKey);
console.log("Address: " + wallet.address);
