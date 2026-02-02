const jsonata = require("jsonata");
const fs = require("fs");

const input = fs.readFileSync(0, "utf-8").trim();

(async () => {
	try {
		await jsonata(input).evaluate();
		process.exit(0);
	} catch (error) {
		const slice = input.slice(0, error.position);
		const line = slice.split("\n").length;
		const column = error.position - slice.lastIndexOf("\n") - 1;
		console.error(`${line}:${column}: ${error.message}`);
		process.exit(1);
	}
})();
