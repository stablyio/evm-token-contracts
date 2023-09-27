import { Wallet } from "ethers";
import crypto from "crypto";

const id: string = crypto.randomBytes(32).toString("hex");
const privateKey: string = "0x" + id;
console.log("Private Key:", privateKey);

const wallet: Wallet = new Wallet(privateKey);
console.log("Address: " + wallet.address);
