-- Dressing renders pretty windows, for things like LSP code actions.
--
-- This is used instead of leveraging eg. Telescope's UI, because they
-- are more concerned with how Telescope works under the hood instead
-- of providing better UI (which libraries like Dressing can provide instead).

require("dressing").setup()
