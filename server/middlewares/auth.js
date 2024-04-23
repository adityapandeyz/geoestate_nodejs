const jwt = require('jsonwebtoken');




const auth = async (req, res, next) => {
    try {
      const token = req.header('x-auth-token');
      if (!token) return res.status(401).json({ msg: 'No auth token, access denied' });
  
      const verified = jwt.verify(token, '0');
      if (!verified) return res.status(401).json({ msg: 'Token verification failed, authorization denied' });
  
      req.user = verified.id;
      req.token = token;
  
      console.log('User:', req.user); // Log the user object
  
      next();
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  };
  



module.exports = auth;