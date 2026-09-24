const router = require('express').Router();
const controller = require('../controllers/product.controller');
const { authenticate } = require('../middleware/auth');

router.use(authenticate);
router.get('/', controller.list);
router.get('/low-stock', controller.lowStock);
router.get('/by-barcode/:barcode', controller.byBarcode);
router.get('/:id', controller.getById);
router.post('/', controller.create);

module.exports = router;
