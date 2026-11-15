## 1.2.0

- **Fix**: the widget never showed the payment form. The page URL is now
  `https://widget-v2.kkiapay.me/?<base64>` (was `?=<base64>`, which the
  widget cannot decode), and the webview is created once instead of being
  rebuilt (and the page reloaded) on every state change.
- **Security / breaking**: the callback no longer reports `SUCCESS` just
  because the widget redirected. The SDK asks the KkiaPay API for the real
  transaction status and calls back with `status` = `SUCCESS`, `FAILED`,
  `PENDING` or `CANCELLED`, plus `isPaymentSuccess` and `widgetEvent`.
  Always check `status` (and confirm server side before delivering).
- The callback is also called with `CANCELLED` when the customer closes
  the widget (widget events are read from `SDK_CHANNEL`).
- The redirect is matched on the exact host `redirect.kkiapay.me`, over HTTPS.
- A load error shows a message with a retry button instead of an endless
  loader.
- No more logging of the widget URL (api key, customer data), payment
  requests, transaction statuses or raw API error bodies; no `print()`.
- Native MoMo flow: `initSession` no longer targets the offline staging
  host `temporal-staging.kkiapay.me`.
- Requires Dart 3 (`sdk: '>=3.0.0 <4.0.0'`); compatible with logger 2.x.

## 1.1.0

- change webview plugin.

## 1.0.6

- update flutter webview plugin to latest version.

## 1.0.5

- add support for flutter last version

## 1.0.3

- remove appbar

## 1.0.2

- add type for callback

## 1.0.0

- kkiapay official release

## 0.5.0

- add docs

# 0.2.0

- refactor

## 0.0.2

- Initial version, created by kkiapay

## 0.1.0

- add description and fix version issue
