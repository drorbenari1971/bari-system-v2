// "הזמנה חדשה": catalog, preview, issue (create client + receipt at the provider), and orders.
const connectionParam = (v) => {
  const id = Number(v);
  if (!Number.isInteger(id) || id < 1) throw new AccountingError('חסר חיבור', { code: 'validation' });
  return id;
};
router.get('/orders/catalog', wrap(async (req, res) => res.json(await orders.catalog(connectionParam(req.query.connectionId)))));

router.post('/orders/preview', wrap(async (req, res) => {
  const { connectionId, order } = req.body ?? {};
  res.set('Cache-Control', 'no-store').json(await orders.previewOrder(connectionParam(connectionId), order));
}));

router.post('/orders', wrap(async (req, res) => {
  const { connectionId, orderKey, order } = req.body ?? {};
  res.json(await orders.submitOrder(connectionParam(connectionId), orderKey, order));
}));

router.get('/orders', (req, res) => {
  const { status, page, pageSize } = req.query;
  res.json(orders.listOrders({ status, page, pageSize }));
});

router.get('/orders/:id', wrap(async (req, res) => {
  const order = orders.getOrder(idParam(req));
  if (!order) throw new AccountingError('ההזמנה לא נמצאה', { code: 'not_found' });
  res.json(order);
}));

router.post('/orders/:id/reconcile', wrap(async (req, res) => res.json(await orders.reconcileOrder(idParam(req)))));
