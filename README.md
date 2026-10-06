# 🐻‘s Money V1

## 需要
- GitHub
- Supabase
- Vercel（或其他靜態網站部署）

## 1. Supabase
1. 建立一個新的 Supabase Project。
2. 到 SQL Editor。
3. 把 `supabase.sql` 全部貼上並執行。
4. 到 Project Settings → API，取得 Project URL 與 anon public key。

## 2. index.html
打開 `index.html`，找到：

const SUPABASE_URL = "YOUR_SUPABASE_URL";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";

替換成你的 Supabase URL / anon public key。

注意：前端使用 anon public key 是正常的；真正的資料保護靠 Supabase RLS。不要把 service_role key 放進前端。

## 3. GitHub
把 `index.html`、`supabase.sql`、`README.md` 上傳到 Repository。

## 4. Vercel
Import GitHub Repository，直接部署即可。

## V1 已包含
- Email / 密碼註冊登入
- 每個帳號自己的資料
- RLS 資料隔離
- 收入／支出記帳
- 帳戶與餘額
- 預購／待付款
- 分期管理
- 分期歷史補登
- 固定繳費
- 儲蓄目標
- Dashboard
- 手機版介面

## 分期歷史補登邏輯
新增分期時填「已繳期數」，例如 12 期已繳 6 期：
- 系統顯示 6 / 12
- 剩餘 6 期
- 已繳的 6 期不會自動新增成今天或本月的支出
- 這些只是歷史紀錄

下一版可以再加入：
- 每一期獨立的實際繳款日期
- 每一期「已繳／待繳／逾期」
- 繳款後自動產生交易
- 轉帳
- 信用卡帳單
- 月預算
- CSV 匯出
- 深色模式
