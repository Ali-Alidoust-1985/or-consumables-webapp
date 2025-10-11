<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="utf-8">
    <title>دیکته پزشکی – ASR</title>
    <style>
        @font-face{font-family:'Vazirmatn';src:url('<%=request.getContextPath()%>/fonts/farsi-fonts/vazir-font-/Vazir-Thin.woff2') format('woff2');font-weight:400;font-style:normal;font-display:swap;}
        @font-face{font-family:'Vazirmatn';src:url('<%=request.getContextPath()%>/fonts/farsi-fonts/vazir-font-/Vazir-Bold.woff2') format('woff2');font-weight:700;font-style:normal;font-display:swap;}
        :root{--bg:#0b1220;--card:#111827;--muted:#94a3b8;--text:#e5e7eb;--accent:#22c55e;--accent2:#3b82f6;--danger:#ef4444;--border:#1f2937;--ink:#0d1426;}
        *{box-sizing:border-box}
        body{margin:0;background:linear-gradient(180deg,#0b1220,#0a0f1a);font-family:"Vazirmatn",system-ui,Segoe UI,Arial;color:var(--text);font-size:19px;}
        .container{max-width:1200px;margin:44px auto;padding:0 20px}
        .title{font-size:32px;font-weight:700}
        .badge{font-size:14px;padding:8px 12px;border:1px solid var(--border);border-radius:999px;color:var(--muted)}
        .grid{display:grid;grid-template-columns:1fr;gap:22px}
        @media(min-width:900px){.grid{grid-template-columns:1.1fr .9fr}}
        .card{background:var(--card);border:1px solid var(--border);border-radius:18px;padding:20px;box-shadow:0 8px 28px rgba(0,0,0,.25)}
        .row{display:flex;gap:12px;align-items:center;flex-wrap:wrap}
        .label{color:var(--muted);font-size:16px}
        .input,.textarea{width:100%;background:var(--ink);color:var(--text);border:1px solid var(--border);border-radius:14px;padding:14px 16px;outline:0;transition:border .2s;font-size:19px;}
        .textarea{height:360px;line-height:2.05}
        .btn{border:0;border-radius:14px;padding:12px 18px;font-weight:800;cursor:pointer;background:#1f2937;color:#e5e7eb;font-size:16px}
        .btn.primary{background:var(--accent2)}
        .btn.success{background:var(--accent)}
        .btn.danger{background:var(--danger)}
        .status{font-size:14px;color:#cbd5e1;padding:6px 12px;border-radius:999px;border:1px solid var(--border)}
        .status.idle{color:#eab308;border-color:#eab30833}
        .status.live{color:#22c55e;border-color:#22c55e33}
        .status.closed{color:#f97316;border-color:#f9731633}
        .hint{font-size:14px;color:var(--muted)}
        .footer{display:flex;justify-content:space-between;align-items:center;margin-top:12px}
        .console{background:#0c1324;border:1px solid #1f2a44;border-radius:14px;padding:10px;max-height:160px;overflow:auto;font-size:13px;direction:ltr}
        details summary{cursor:pointer;color:#9fb3d8}
        .pill{display:inline-flex;align-items:center;gap:8px;padding:8px 12px;border-radius:999px;border:1px solid var(--border);background:rgba(255,255,255,.03)}
        .dot{width:8px;height:8px;border-radius:50%}
        .dot.green{background:#22c55e}.dot.amber{background:#eab308}.dot.red{background:#ef4444}
    </style>
</head>
<body>
<div class="container">
    <div class="row" style="justify-content:space-between;margin-bottom:14px">
        <div class="title">نرم‌افزار دیکته پزشکی</div>
        <span class="badge">Java (WS) ⇄ Python (ASR)</span>
    </div>

    <div class="grid">
        <!-- کنترل جلسه -->
        <section class="card">
            <div class="row" style="gap:12px;margin-bottom:12px">
                <span class="label">شناسهٔ جلسه:</span>
                <input id="dictId" class="input" style="width:170px" placeholder="(خودکار پر می‌شود)" />
                <button id="btnStart" class="btn success">شروع</button>
                <button id="btnStop" class="btn danger" disabled>پایان</button>

                <span id="state" class="status idle pill">
          <span class="dot amber"></span>
          <span id="stateText">idle</span>
        </span>
            </div>

            <div class="row" style="gap:12px;margin:8px 0">
                <span class="label">راهنما:</span>
                <span class="hint">با «شروع»، جلسه ساخته می‌شود، وب‌سوکت باز می‌شود و میکروفون فعال می‌شود. فقط متن نهایی اینجا نمایش داده می‌شود.</span>
            </div>

            <label class="label" for="final">متن نهایی (قابل ویرایش)</label>
            <textarea id="final" class="textarea" placeholder="اینجا متن نهایی می‌آید…"></textarea>

            <div class="footer">
                <div class="hint">* 16kHz PCM • Mono • فارسی + مخفف‌های پزشکی انگلیسی</div>
                <div class="row" style="gap:8px">
                    <button id="btnCopy" class="btn">کپی</button>
                    <button id="btnSave" class="btn primary">ذخیرهٔ نهایی</button>
                </div>
            </div>
        </section>

        <!-- دیباگ سبک -->
        <section class="card">
            <div class="row" style="justify-content:space-between">
                <span class="label">دیباگ اتصال</span>
                <span class="hint">WS: <code id="wsUrlView"></code></span>
            </div>
            <details style="margin-top:10px">
                <summary>باز کردن لاگ</summary>
                <div id="log" class="console"></div>
            </details>
            <div class="hint" style="margin-top:10px">کیفیت میکروفون و نزدیکی به دهان روی دقت اثر مستقیم دارد.</div>
        </section>
    </div>
</div>

<script>
    (function(){
        const ctx = '<%=request.getContextPath()%>';
        const wsUrl = (location.protocol === 'https:' ? 'wss://' : 'ws://') + location.host + ctx + '/ws/dictation';
        document.getElementById('wsUrlView').textContent = wsUrl;

        let audioCtx=null, proc=null, mic=null, ws=null, pollTimer=null;
        let currentDictId=null;
        let lastPartialText = ''; // فقط نگه‌داری داخلی
        let appendedFinals = '';  // برای اجتناب از تکرار join

        const $ = id => document.getElementById(id);
        const log = (...a)=>{ const el=$('log'); el && el.append((new Date()).toISOString().slice(11,19)+'  '+a.join(' ')+'\n'); el && (el.scrollTop=el.scrollHeight); };
        const setState = (mode,text)=>{
            const st=$('state'); const tx=$('stateText'); const dot=st.querySelector('.dot');
            st.className = 'status pill ' + (mode==='live'?'live':mode==='closed'?'closed':'idle');
            dot.className = 'dot ' + (mode==='live'?'green':mode==='closed'?'red':'amber');
            tx.textContent = text;
        };

        $('btnStart').onclick = start;
        $('btnStop').onclick  = stop;
        $('btnCopy').onclick  = ()=>{ const t=$('final').value||''; navigator.clipboard?.writeText(t); log('copied', t.slice(0,48).replace(/\n/g,' ')+'...'); };
        $('btnSave').onclick  = save;

        async function start(){
            try{
                $('btnStart').disabled = true;
                setState('idle','starting…');
                log('POST /api/dictations …');

                // 1) ساخت جلسه
                const resp = await fetch(ctx + '/api/dictations', {
                    method: 'POST',
                    headers: {'Content-Type':'application/json','X-User':'demo'},
                    body: JSON.stringify({ departmentCode:'ER', language:'fa', modelHint:'vosk', initialPrompt:'' })
                });
                const dto = await resp.json();
                if(!resp.ok || !dto.id) throw new Error('Start API failed');
                currentDictId = dto.id; $('dictId').value = dto.id; log('Dictation id=', dto.id);

                // 2) باز کردن WebSocket
                ws = new WebSocket(wsUrl);
                ws.binaryType = 'arraybuffer';

                ws.onopen = async ()=>{
                    log('WS open → send start');
                    ws.send(JSON.stringify({
                        type:'start', dictationId:currentDictId, sampleRate:16000, language:'fa',
                        partials:false // چون فقط نهایی را نمایش می‌دهیم؛ پایتون همچنان می‌تواند partial بفرستد ولی ما نادیده می‌گیریم
                    }));
                    await openMicAndStartStream();
                    setState('live','listening…');
                    startPollingSegments();
                    $('btnStop').disabled = false;
                };

                // 🔴 مهم: پیام‌های WS را هم مصرف می‌کنیم تا متن نهایی «بلادرنگ» بیاید
                ws.onmessage = (ev)=>{
                    try{
                        const m = JSON.parse(typeof ev.data==='string' ? ev.data : '');
                        if (m && m.type === 'final' && m.text){
                            // فقط نهایی‌ها را به انتهای باکس اضافه کن
                            const cur = $('final').value || '';
                            const next = (cur ? (cur + ' ') : '') + m.text;
                            $('final').value = next;
                            appendedFinals = next;
                        } else if (m && m.type === 'partial' && m.text){
                            lastPartialText = m.text; // فعلاً نمایش نمی‌دهیم
                        } else if (m && m.type === 'done'){
                            // می‌توانیم اینجا stop خودکار بزنیم؛ ترجیحاً نه.
                        }
                    }catch(e){
                        // اگر متن JSON نبود (لاگ)، عبور
                    }
                };

                ws.onclose = (ev)=>{ log('WS close', ev.code, ev.reason||''); cleanupAudio(); stopPolling(); setState('closed','closed'); $('btnStart').disabled=false; $('btnStop').disabled=true; };
                ws.onerror = (ev)=>{ log('WS error', ev?.message||ev); cleanupAudio(); stopPolling(); setState('closed','error'); $('btnStart').disabled=false; $('btnStop').disabled=true; };
            }catch(err){
                log('ERROR start():', err.message||err);
                alert('اشکال در شروع: '+err);
                setState('idle','idle'); $('btnStart').disabled=false; $('btnStop').disabled=true;
            }
        }

        async function openMicAndStartStream(){
            audioCtx = new (window.AudioContext||window.webkitAudioContext)({ sampleRate:16000 });
            if (audioCtx.state==='suspended') await audioCtx.resume();
            log('getUserMedia…');

            mic = await navigator.mediaDevices.getUserMedia({
                audio:{channelCount:1, sampleRate:16000, echoCancellation:true, noiseSuppression:true}
            });
            const source = audioCtx.createMediaStreamSource(mic);

            proc = audioCtx.createScriptProcessor(4096, 1, 1);
            proc.onaudioprocess = (e)=>{
                if(!ws || ws.readyState!==WebSocket.OPEN) return;
                const f32 = e.inputBuffer.getChannelData(0);
                const pcm = floatTo16BitPCM(f32);
                ws.send(pcm.buffer); // باینری خام
            };
            source.connect(proc);
            // جلوگیری از سایلنس خودکار بعضی مرورگرها—نگه‌داشتن graph:
            proc.connect(audioCtx.destination);
        }

        async function stop(){
            try{ if(ws && ws.readyState===WebSocket.OPEN) ws.send(JSON.stringify({type:'stop'})); }catch{}
            // کمی صبر تا final/done برسد و در جاوا ثبت شود
            await new Promise(r=>setTimeout(r, 800));
            cleanupAudio(); stopPolling();
            try{ ws && ws.close(); }catch{}
            ws = null;

            // Poll نهایی برای sync با DB
            try{
                if(currentDictId){
                    const resp = await fetch(ctx + '/api/dictations/'+currentDictId+'/segments',{headers:{'Accept':'application/json'}});
                    if(resp.ok){
                        const segs = await resp.json();
                        const finals = segs.filter(s=>s.isFinal).map(s=>s.text).join(' ');
                        if(finals && finals.length > (appendedFinals||'').length){
                            $('final').value = finals;
                            appendedFinals = finals;
                        }
                    }
                }
            }catch{}
            $('btnStart').disabled=false; $('btnStop').disabled=true; setState('idle','idle'); log('stopped.');
        }

        async function save(){
            const id = Number(($('dictId').value||'0').trim());
            const text = $('final').value||'';
            const resp = await fetch(ctx + '/api/dictations/'+id+'/finalize', {
                method:'POST', headers:{'Content-Type':'application/json','X-User':'demo'},
                body: JSON.stringify({text, finalize:true})
            });
            alert(resp.ok ? 'ذخیره شد' : 'خطا در ذخیره');
        }

        function startPollingSegments(){
            stopPolling();
            pollTimer = setInterval(async ()=>{
                if(!currentDictId) return;
                try{
                    const resp = await fetch(ctx + '/api/dictations/'+currentDictId+'/segments',{headers:{'Accept':'application/json'}});
                    if(!resp.ok) return;
                    const segs = await resp.json();
                    const finals = segs.filter(s=>s.isFinal).map(s=>s.text).join(' ');
                    // فقط اگر از آنچه قبلاً append کرده‌ایم طولانی‌تر بود، جایگزین کن (جلوگیری از overwrite عقب‌گردی)
                    if(finals && finals.length > (appendedFinals||'').length){
                        $('final').value = finals;
                        appendedFinals = finals;
                    }
                    log('segments:', segs.length);
                }catch(e){}
            }, 1000);
        }
        function stopPolling(){ if(pollTimer) clearInterval(pollTimer); pollTimer=null; }

        function cleanupAudio(){
            try{ proc && proc.disconnect(); }catch{}
            try{ audioCtx && audioCtx.close(); }catch{}
            try{ mic && mic.getTracks().forEach(t=>t.stop()); }catch{}
            proc=null; audioCtx=null; mic=null;
        }

        // helper: Float32 → PCM16LE
        function floatTo16BitPCM(f32){
            const buf = new ArrayBuffer(f32.length*2);
            const view = new DataView(buf);
            for(let i=0, off=0;i<f32.length;i++, off+=2){
                let s=Math.max(-1, Math.min(1, f32[i]));
                view.setInt16(off, s<0 ? s*0x8000 : s*0x7FFF, true);
            }
            return new Uint8Array(buf);
        }
    })();
</script>
</body>
</html>
