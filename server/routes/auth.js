const express = require("express");
const { PrismaClient } = require("@prisma/client");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");

const authRouter = express.Router();
const prisma = new PrismaClient();

// SIGN UP
authRouter.post("/api/signup", async (req, res) => {
  const { email, password } = req.body;

  try {
    const existingUser = await prisma.user.findFirst({
      where: { email: email },
    });

    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

   bcryptjs.hash(password, 6, async (err, hash) => {
      if (err) {
        return res.status(500).json({ error: err.message });
      }

      try {
        const createdUser = await prisma.user.create({
          data: {
            email,
            password: hash,
            token: "",
          },
        });
        res.status(201).json(createdUser); // Move this line inside the callback
      } catch (err) {
        console.log(err);
        return res.status(500).json({ error: err.message });
      }
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({ error: err.message });
  }
});

// SIGN IN
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const existingUser = await prisma.user.findFirst({
      where: { email: email },
    });
  
    if (!existingUser) {
      return res.status(400).json({ msg: "User not found!" });
    }

    if (!existingUser.password) {
      return res.status(400).json({ msg: "Password is not set for this user!" });
    }


    const isMatch = await bcryptjs.compare(password, existingUser.password);


    if (!isMatch) { 
      return res.status(400).json({ msg: "Invalid credentials!" });
    }

    const token = jwt.sign({ id: existingUser.id }, "0", { expiresIn: "12h" });

    res.json({
      token,
      user: { id: existingUser.id, email: existingUser.email },
    });
  } catch (err) {
    console.log(err);
    return res.status(500).json({ error: err.message });
  }
});


authRouter.post('/tokenIsValid', async (req, res)=> {
  try{
   const token=req.header('x-auth-token');

   if(!token) return res.json(false);

   const verified = jwt.verify(token, '0');

   if(!verified) return res.json(false);

   const user = await prisma.user.findFirst({ where: { id: verified.id } });

   if(!user) return res.json(false);

   res.json(true);

  } catch(e){
    res.status(500).json({error:e.message});
  }
});

// get user data 
authRouter.get('/', auth, async (req, res) => {
  try {
    const user = await prisma.user.findFirst({ where: { id: req.user.id } });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ ...user, token: req.token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


module.exports = authRouter;
