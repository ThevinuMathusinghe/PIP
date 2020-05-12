function errorHandler(error, res, res, next) {
  return res.status(error.status || 500).json({
    error: {
      message:
        error.message || 'Opps something went wrong, please try again later'
    }
  });
}

module.exports = errorHandler;
