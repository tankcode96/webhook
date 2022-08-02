let http = require("http");
const { createHmac } = require("crypto");
const { spawn, ChildProcess } = require("child_process");

// webhook 加密密钥
const SECRET = "tan6300853";

function sign(body) {
  return `sha1=${createHmac("sha1", SECRET).update(body).digest("hex")}`;
}

let server = http.createServer(function (req, res) {
  console.log("webhook 被调用");
  if (req.method === "POST" && req.url === "/webhook") {
    const buffers = [];
    req.on("data", (buffer) => {
      buffers.push(buffer);
    });
    req.on("end", () => {
      let body = Buffer.concat(buffers);
      // github 事件
      let event = req.header["x-github-event"];
      // github传递的签名
      let signature = req.headers["x-hub-signature"];
      if (signature !== sign(body)) {
        return res.end("Not Allowed");
      }
      res.setHeader("Content-type", "application/json");
      res.end(JSON.stringify({ ok: true }));
      // 开始部署
      if (event === "push") {
        const payload = JSON.parse(body);
        const child = spawn("sh", [`./${payload.reposity.name}.sh`]);
        const buffers = [];
        child.stdout.on("data", (buffer) => {
          buffers.push(buffer);
        });
        child.stdout.on("end", (buffer) => {
          const log = Buffer.concat(buffers);
          console.log(log);
        });
      }
    });
  } else {
    res.end("Not Found");
  }
});

server.listen(4000, () => {
  console.log("webhook 服务已经在4000端口上启动");
});
