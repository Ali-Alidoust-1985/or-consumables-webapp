<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="utf-8">
    <title>تست دیکته – ASR</title>
    <style>
        @font-face{
            font-family:'Vazirmatn';
            src:url('<%=request.getContextPath()%>/fonts/farsi-fonts/vazir-font-/Vazir-Thin.woff2') format('woff2');
            font-weight:400;font-style:normal;font-display:swap;
        }
        @font-face{
            font-family:'Vazirmatn';
            src:url('<%=request.getContextPath()%>/fonts/farsi-fonts/vazir-font-/Vazir-Bold.woff2') format('woff2');
            font-weight:700;font-style:normal;font-display:swap;
        }
        body{font-family:"Vazirmatn",system-ui,Segoe UI,Arial}
    </style>


    <style>
        :root{
            --bg:#0b1220; --card:#111827; --muted:#94a3b8; --text:#e5e7eb; --accent:#22c55e; --accent2:#3b82f6; --danger:#ef4444; --border:#1f2937;
        }
        *{box-sizing:border-box}
        body{
            margin:0; background:linear-gradient(180deg,#0b1220,#0a0f1a);
            font-family:"Vazirmatn",system-ui,Segoe UI,Arial; color:var(--text);
            font-size:18px; /* ← بزرگ‌تر */
        }
        .container{max-width:1200px;margin:48px auto;padding:0 20px}
        .title{font-size:32px;font-weight:700}
        .badge{font-size:14px;padding:6px 12px;border:1px solid var(--border);border-radius:999px;color:var(--muted)}
        .grid{display:grid;grid-template-columns:1fr;gap:20px}
        @media(min-width:900px){ .grid{grid-template-columns: 1.2fr .8fr} }

        .card{
            background:var(--card); border:1px solid var(--border); border-radius:16px; padding:20px;
            box-shadow:0 8px 28px rgba(0,0,0,.25);
        }
        .row{display:flex;gap:12px;align-items:center;flex-wrap:wrap}
        .label{color:var(--muted);font-size:16px}
        .input, .textarea{
            width:100%; background:#0d1426; color:var(--text); border:1px solid var(--border);
            border-radius:12px; padding:12px 14px; outline:0; transition:border .2s; font-size:18px;
        }
        .textarea{height:280px; line-height:2} /* ← بلندتر */
        .btn{
            border:0; border-radius:12px; padding:12px 18px; font-weight:700; cursor:pointer;
            background:#1f2937; color:#e5e7eb; font-size:16px;
        }
        .btn.primary{ background:var(--accent2) }
        .btn.success{ background:var(--accent) }
        .btn.danger{ background:var(--danger) }
        .status{font-size:14px; color:#cbd5e1; padding:6px 12px; border-radius:999px; border:1px solid var(--border)}
        .status.idle{ color:#eab308; border-color:#eab30833 }
        .status.streaming{ color:#22c55e; border-color:#22c55e33 }
        .status.closed{ color:#f97316; border-color:#f9731633 }
        .hint{font-size:14px;color:var(--muted)}
        .footer{display:flex;justify-content:space-between;align-items:center;margin-top:12px}
        .tag{font-size:14px;color:#a5b4fc;background:#11153a;border:1px solid #2b3299;padding:6px 10px;border-radius:10px}
    </style>
</head>
<body>
<div class="container">
    <div class="row" style="justify-content:space-between;margin-bottom:16px">
        <div class="title">نرم افزار تبدیل Voice به متن پزشکی - بیمارستان فیروزگر</div>
        <span class="badge">WebSocket + Mock ASR</span>
    </div>

    <div class="grid">
        <section class="card">
            <div class="row" style="gap:12px;margin-bottom:12px">
                <span class="label">شناسهٔ جلسه:</span>
                <input id="dictId" class="input" style="width:140px" value="1001" />
                <button id="btnStart" class="btn success">شروع</button>
                <button id="btnStop" class="btn danger" disabled>پایان</button>
                <span id="state" class="status idle">idle</span>
            </div>

            <div class="row" style="gap:12px;margin:8px 0">
                <span class="label">توضیح:</span>
                <span class="hint">فعلاً خروجی Mock است؛ بعدی را به ASR واقعی وصل می‌کنیم.</span>
            </div>

            <label class="label" for="partial">متن موقت</label>
            <textarea id="partial" class="textarea" placeholder="(Mock ASR فعلاً … می‌نویسد)"></textarea>

            <div class="footer">
                <div class="hint">* 16kHz PCM • Mono</div>
                <div class="tag">RTL • فارسی</div>
            </div>
        </section>

        <section class="card">
            <div class="row" style="justify-content:space-between;margin-bottom:8px">
                <span class="label">متن نهایی (قابل ویرایش)</span>
                <button id="btnCopy" class="btn">کپی متن</button>
            </div>
            <textarea id="final" class="textarea" placeholder="اینجا می‌تونی متن را ویرایش کنی…"></textarea>

            <div class="footer">
                <span id="saveState" class="status">—</span>
                <button id="btnSave" class="btn primary">ذخیرهٔ نهایی</button>
            </div>
        </section>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const ctx = '<%=request.getContextPath()%>';
        const wsUrl = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + ctx + '/ws/dictation';

        let audioCtx, scriptNode, micStream, ws;

        const $ = id => document.getElementById(id);
        const setState = (cls, text) => {
            const st = $('state');
            st.className = 'status ' + cls;
            st.textContent = text;
        };

        $('btnStart').onclick = start;
        $('btnStop').onclick = stop;
        $('btnSave').onclick = save;
        $('btnCopy').onclick = () => {
            const text = $('final').value || $('partial').value;
            navigator.clipboard?.writeText(text);
        };

        async function start(){
            try{
                const dictId = Number(($('dictId').value || '').trim());
                if(!dictId) return alert('شناسهٔ جلسه نامعتبر است');

                ws = new WebSocket(wsUrl);
                ws.onopen = () => {
                    ws.send(JSON.stringify({type:'start', dictationId: dictId, sampleRate:16000}));
                    setState('streaming','streaming');
                };
                ws.onclose = () => setState('closed','closed');

                // میکروفون — روی localhost یا HTTPS مجازه
                audioCtx = new (window.AudioContext || window.webkitAudioContext)({ sampleRate: 16000 });
                micStream = await navigator.mediaDevices.getUserMedia({
                    audio: { channelCount:1, sampleRate:16000, echoCancellation:true, noiseSuppression:true }
                });
                const source = audioCtx.createMediaStreamSource(micStream);

                // دموی سریع با ScriptProcessorNode
                scriptNode = audioCtx.createScriptProcessor(4096, 1, 1);
                scriptNode.onaudioprocess = (e) => {
                    const f32 = e.inputBuffer.getChannelData(0);
                    const pcm = floatTo16BitPCM(f32);
                    if (ws && ws.readyState === 1) {
                        ws.send(JSON.stringify({type:'audio', base64: arrayBufferToBase64(pcm.buffer)}));
                    }
                    // Mock: نمایش «…»
                    $('partial').value = ($('partial').value + '…').slice(-3000);
                };

                source.connect(scriptNode);
                scriptNode.connect(audioCtx.destination);

                $('btnStart').disabled = true;
                $('btnStop').disabled = false;
            }catch(err){
                console.error(err);
                alert('اشکال در شروع: ' + err);
                setState('idle','idle');
            }
        }

        function stop(){
            try{
                ws && ws.send(JSON.stringify({type:'stop'}));
                scriptNode && scriptNode.disconnect();
                audioCtx && audioCtx.close();
                micStream && micStream.getTracks().forEach(t=>t.stop());
            }catch{}
            $('btnStart').disabled = false;
            $('btnStop').disabled = true;
        }

        async function save(){
            const id = Number(($('dictId').value || '0').trim());
            const text = $('final').value || $('partial').value;
            const resp = await fetch(ctx + '/api/dictations/' + id + '/finalize', {
                method: 'POST',
                headers: {'Content-Type':'application/json', 'X-User':'demo'},
                body: JSON.stringify({text, finalize:true})
            });
            $('saveState').textContent = resp.ok ? 'ذخیره شد' : 'خطا';
            $('saveState').className = 'status ' + (resp.ok ? 'streaming' : 'closed');
        }

        function floatTo16BitPCM(f32){
            const buf = new ArrayBuffer(f32.length*2);
            const view = new DataView(buf);
            for (let i=0, off=0; i<f32.length; i++, off+=2) {
                let s = Math.max(-1, Math.min(1, f32[i]));
                view.setInt16(off, s<0 ? s*0x8000 : s*0x7FFF, true);
            }
            return new Uint8Array(buf);
        }
        function arrayBufferToBase64(buffer){
            let binary = '', bytes = new Uint8Array(buffer), chunk = 0x8000;
            for (let i=0;i<bytes.length;i+=chunk) {
                binary += String.fromCharCode.apply(null, bytes.subarray(i, i+chunk));
            }
            return btoa(binary);
        }
    });
</script>
</body>
</html>
