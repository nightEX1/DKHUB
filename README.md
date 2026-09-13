# Termux Lua GitHub Bot

ต้นแบบนี้รับคำสั่งจาก Termux แล้วสร้างไฟล์ Lua ใน `scripts/generated/` จากนั้นให้ผู้ใช้ยืนยันก่อน commit/push เข้า GitHub

## ทดลองแบบไม่ใช้ API ก่อน

```bash
pkg install python git gh -y
mkdir -p ~/lua-bot
cd ~/lua-bot
# นำไฟล์ bot.py นี้มาไว้ในโฟลเดอร์ repo ของคุณ
python bot.py
```

ถ้ายังไม่มี `OPENAI_API_KEY` โปรแกรมจะใช้ **โหมด Demo** และสร้างไฟล์ placeholder เพื่อทดสอบลำดับการทำงานโดยไม่เรียก AI

## ใช้ AI จริง

ตั้งค่าคีย์เฉพาะใน session ปัจจุบัน (อย่าใส่ลงไฟล์หรือ GitHub):

```bash
export OPENAI_API_KEY='ใส่คีย์ของคุณ'
export OPENAI_API_BASE='https://api.openai.com/v1'
export AI_MODEL='gpt-5-mini'
python bot.py
```

ถ้าใช้ endpoint ที่เข้ากันได้กับ OpenAI ให้เปลี่ยน `OPENAI_API_BASE` ตามผู้ให้บริการนั้น

## เชื่อม GitHub ของคุณ

ในโฟลเดอร์ repository ของคุณ:

```bash
gh auth login
gh auth status
git remote -v
python bot.py
```

บอทจะเขียนไฟล์, แสดงตัวอย่าง, แล้วถามยืนยัน โดยต้องพิมพ์ `YES` จึงจะ `git add`, `git commit`, `git push`

## สร้าง repo ใหม่

```bash
mkdir -p ~/projects && cd ~/projects
gh repo create ai-lua-bot --private --clone
cd ai-lua-bot
mkdir -p scripts/generated
cp /path/to/bot.py .
python bot.py
```

## ขอบเขตความปลอดภัย

บอทนี้ตั้งใจให้สร้าง Lua สำหรับ Roblox Studio ที่ปลอดภัยเท่านั้น ไม่สร้าง exploit/cheat, ขโมย Token, ข้ามระบบความปลอดภัย หรือทำลายข้อมูล และจำกัดชื่อไฟล์ให้อยู่ใต้ `scripts/generated/`

อย่าใส่ API key, GitHub token หรือข้อมูลลับลงใน repository หากต้องการ URL แบบ `raw.githubusercontent.com` ให้ repository และไฟล์นั้นเป็น Public; repository Private จะไม่เปิดให้ผู้ใช้ทั่วไปเรียก URL raw ได้
