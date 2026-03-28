<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HealthOS ? Future of Healthcare</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=DM+Sans:ital,wght@0,300;0,400;0,500;1,300&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
/* ???????????????????????????????????????????????
   TOKENS
??????????????????????????????????????????????? */
:root {
  --void: #030508;
  --deep: #060A10;
  --panel: #0B1018;
  --glass: rgba(255,255,255,0.04);
  --rim: rgba(255,255,255,0.08);
  --rim2: rgba(255,255,255,0.04);

  --teal: #00D4B4;
  --teal2: #00A896;
  --blue: #0EA5E9;
  --violet: #7C3AED;
  --ember: #F97316;
  --rose: #F43F5E;
  --lime: #84CC16;

  --t1: #F8FAFC;
  --t2: #94A3B8;
  --t3: #475569;

  --f-display: 'Syne', sans-serif;
  --f-body: 'DM Sans', sans-serif;
  --f-mono: 'JetBrains Mono', monospace;

  --ease-spring: cubic-bezier(0.34,1.56,0.64,1);
  --ease-smooth: cubic-bezier(0.25,0,0,1);
}

/* ???????????????????????????????????????????????
   RESET / BASE
??????????????????????????????????????????????? */
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth;overflow-x:hidden}
body{
  font-family:var(--f-body);
  background:var(--void);
  color:var(--t1);
  overflow-x:hidden;
  cursor:none;
}

::-webkit-scrollbar{width:4px}
::-webkit-scrollbar-track{background:var(--void)}
::-webkit-scrollbar-thumb{background:var(--teal);border-radius:4px}
::selection{background:rgba(0,212,180,0.25)}

/* ???????????????????????????????????????????????
   CUSTOM CURSOR
??????????????????????????????????????????????? */
#cursor{
  position:fixed;width:12px;height:12px;
  border-radius:50%;background:var(--teal);
  pointer-events:none;z-index:99999;
  transform:translate(-50%,-50%);
  transition:transform 0.08s,width 0.2s,height 0.2s,background 0.2s;
  mix-blend-mode:difference;
}
#cursor-ring{
  position:fixed;width:36px;height:36px;
  border-radius:50%;border:1px solid rgba(0,212,180,0.5);
  pointer-events:none;z-index:99998;
  transform:translate(-50%,-50%);
  transition:transform 0.18s var(--ease-smooth),width 0.3s,height 0.3s,border-color 0.3s;
}
body:has(a:hover) #cursor{width:20px;height:20px;background:var(--teal)}
body:has(button:hover) #cursor{width:20px;height:20px;background:var(--ember)}

/* ???????????????????????????????????????????????
   GLOBAL AMBIENT BACKGROUND
??????????????????????????????????????????????? */
.ambient{
  position:fixed;inset:0;pointer-events:none;z-index:0;
  background:
    radial-gradient(ellipse 60% 50% at 20% 20%, rgba(0,212,180,0.06) 0%, transparent 60%),
    radial-gradient(ellipse 40% 60% at 80% 80%, rgba(14,165,233,0.05) 0%, transparent 60%),
    radial-gradient(ellipse 50% 40% at 60% 10%, rgba(124,58,237,0.04) 0%, transparent 60%);
  animation:ambientShift 20s ease-in-out infinite alternate;
}
@keyframes ambientShift{
  0%{opacity:1}
  50%{opacity:0.7}
  100%{opacity:1;filter:hue-rotate(20deg)}
}

/* ???????????????????????????????????????????????
   FLOATING NAVBAR ? UNIQUE PILL DESIGN
??????????????????????????????????????????????? */
.nav-wrap{
  position:fixed;top:20px;left:50%;transform:translateX(-50%);
  z-index:1000;width:calc(100% - 40px);max-width:1100px;
  transition:top 0.3s var(--ease-smooth);
}
.nav-inner{
  display:flex;align-items:center;justify-content:space-between;
  padding:0 8px 0 16px;height:58px;
  background:rgba(6,10,16,0.82);
  border:1px solid var(--rim);
  border-radius:100px;
  backdrop-filter:blur(24px) saturate(180%);
  -webkit-backdrop-filter:blur(24px) saturate(180%);
  box-shadow:0 8px 32px rgba(0,0,0,0.5),inset 0 1px 0 rgba(255,255,255,0.06);
  transition:box-shadow 0.3s;
}
.nav-inner:hover{box-shadow:0 8px 40px rgba(0,0,0,0.6),0 0 0 1px rgba(0,212,180,0.08),inset 0 1px 0 rgba(255,255,255,0.08)}

/* Logo */
.nav-logo{
  display:flex;align-items:center;gap:10px;
  text-decoration:none;flex-shrink:0;
}
.logo-mark{
  width:34px;height:34px;border-radius:10px;
  background:linear-gradient(135deg,var(--teal),var(--blue));
  display:flex;align-items:center;justify-content:center;
  position:relative;overflow:hidden;
}
.logo-mark::after{
  content:'';position:absolute;inset:-1px;
  background:linear-gradient(135deg,transparent 30%,rgba(255,255,255,0.15));
  border-radius:10px;
}
.logo-ecg{
  width:22px;height:14px;stroke:white;fill:none;
  stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;
  animation:ecgDraw 2.5s ease-in-out infinite;
}
@keyframes ecgDraw{
  0%,100%{stroke-dashoffset:0;opacity:1}
  50%{opacity:0.7}
}
.logo-name{
  font-family:var(--f-display);font-weight:700;
  font-size:1rem;letter-spacing:-0.02em;color:var(--t1);
}
.logo-name sup{
  font-size:0.55rem;font-weight:500;color:var(--teal);
  vertical-align:super;letter-spacing:0.1em;
  font-family:var(--f-mono);
}

/* Center links */
.nav-links{
  display:flex;align-items:center;gap:2px;
  list-style:none;
}
.nav-links a{
  font-size:0.82rem;font-weight:500;color:var(--t2);
  text-decoration:none;padding:7px 14px;border-radius:100px;
  transition:all 0.18s;white-space:nowrap;
  font-family:var(--f-body);
}
.nav-links a:hover{color:var(--t1);background:var(--glass)}
.nav-links a.active{color:var(--teal);background:rgba(0,212,180,0.08)}

/* Dropdown */
.nav-dd{position:relative}
.nav-dd-menu{
  position:absolute;top:calc(100% + 12px);left:50%;
  transform:translateX(-50%) translateY(-8px) scale(0.96);
  background:rgba(11,16,24,0.98);
  border:1px solid var(--rim);border-radius:16px;
  padding:8px;min-width:180px;
  opacity:0;pointer-events:none;
  transition:all 0.22s var(--ease-spring);
  backdrop-filter:blur(24px);
  box-shadow:0 20px 60px rgba(0,0,0,0.5);
}
.nav-dd:hover .nav-dd-menu{opacity:1;pointer-events:all;transform:translateX(-50%) translateY(0) scale(1)}
.nav-dd-menu a{
  display:flex;align-items:center;gap:10px;
  padding:10px 12px;border-radius:10px;
  font-size:0.8rem;color:var(--t2);text-decoration:none;
  transition:all 0.15s;
}
.nav-dd-menu a:hover{background:rgba(0,212,180,0.08);color:var(--teal)}
.dd-icon{
  width:28px;height:28px;border-radius:7px;
  display:flex;align-items:center;justify-content:center;
  flex-shrink:0;font-size:0.85rem;
}

/* CTA area */
.nav-cta{display:flex;align-items:center;gap:8px}
.btn-nav-ghost{
  font-size:0.8rem;font-weight:500;color:var(--t2);
  padding:8px 16px;border-radius:100px;
  border:1px solid var(--rim);background:transparent;
  cursor:pointer;transition:all 0.18s;font-family:var(--f-body);
  text-decoration:none;
}
.btn-nav-ghost:hover{border-color:rgba(0,212,180,0.3);color:var(--teal)}
.btn-nav-primary{
  font-size:0.8rem;font-weight:600;color:#000;
  padding:9px 20px;border-radius:100px;
  background:var(--teal);border:none;
  cursor:pointer;transition:all 0.22s var(--ease-spring);
  font-family:var(--f-body);display:flex;align-items:center;gap:6px;
  text-decoration:none;white-space:nowrap;
}
.btn-nav-primary:hover{background:white;transform:scale(1.04);box-shadow:0 0 20px rgba(0,212,180,0.3)}
.btn-nav-primary svg{width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2.5}

/* ???????????????????????????????????????????????
   HERO
??????????????????????????????????????????????? */
.hero{
  min-height:100vh;
  display:flex;align-items:center;
  padding:120px 0 80px;
  position:relative;overflow:hidden;
}

/* 3D Grid floor */
.hero-grid{
  position:absolute;inset:0;pointer-events:none;
  perspective:600px;
}
.grid-plane{
  position:absolute;bottom:0;left:-20%;right:-20%;
  height:70%;
  background-image:
    linear-gradient(rgba(0,212,180,0.07) 1px,transparent 1px),
    linear-gradient(90deg,rgba(0,212,180,0.07) 1px,transparent 1px);
  background-size:60px 60px;
  transform:rotateX(62deg);
  transform-origin:bottom center;
  mask-image:linear-gradient(to top,rgba(0,0,0,0.5) 0%,transparent 60%);
  -webkit-mask-image:linear-gradient(to top,rgba(0,0,0,0.5) 0%,transparent 60%);
}
.grid-plane::after{
  content:'';position:absolute;inset:0;
  background:linear-gradient(to top,var(--void) 0%,transparent 40%);
}

/* Glowing orbs */
.orb{position:absolute;border-radius:50%;filter:blur(80px);pointer-events:none}
.orb-a{width:500px;height:500px;top:-100px;left:-100px;
  background:radial-gradient(circle,rgba(0,212,180,0.15),transparent 70%);
  animation:orbDrift 14s ease-in-out infinite}
.orb-b{width:400px;height:400px;bottom:0;right:-80px;
  background:radial-gradient(circle,rgba(14,165,233,0.1),transparent 70%);
  animation:orbDrift 18s ease-in-out infinite reverse}
.orb-c{width:300px;height:300px;top:50%;right:30%;
  background:radial-gradient(circle,rgba(124,58,237,0.08),transparent 70%);
  animation:orbDrift 22s ease-in-out infinite 4s}
@keyframes orbDrift{
  0%,100%{transform:translate(0,0) scale(1)}
  33%{transform:translate(30px,-30px) scale(1.1)}
  66%{transform:translate(-20px,20px) scale(0.95)}
}

.container{
  max-width:1200px;margin:0 auto;
  padding:0 24px;width:100%;position:relative;z-index:2;
}

.hero-inner{display:grid;grid-template-columns:1fr 1fr;gap:60px;align-items:center}

/* Hero left */
.hero-tag{
  display:inline-flex;align-items:center;gap:8px;
  padding:6px 14px;border-radius:100px;
  border:1px solid rgba(0,212,180,0.25);
  background:rgba(0,212,180,0.06);
  font-size:0.72rem;font-weight:500;color:var(--teal);
  font-family:var(--f-mono);letter-spacing:0.08em;
  margin-bottom:28px;
  animation:fadeSlideUp 0.6s ease both;
}
.pulse-dot{
  width:7px;height:7px;border-radius:50%;background:var(--teal);
  animation:pulse 2s ease-in-out infinite;
}
@keyframes pulse{0%,100%{box-shadow:0 0 0 0 rgba(0,212,180,0.5)}50%{box-shadow:0 0 0 6px transparent}}

.hero-h1{
  font-family:var(--f-display);
  font-size:clamp(3rem,5.5vw,4.8rem);
  font-weight:800;letter-spacing:-0.04em;line-height:0.95;
  color:var(--t1);margin-bottom:24px;
  animation:fadeSlideUp 0.6s ease 0.1s both;
}
.hero-h1 .line-accent{
  background:linear-gradient(90deg,var(--teal),var(--blue));
  -webkit-background-clip:text;-webkit-text-fill-color:transparent;
  background-clip:text;
}
.hero-h1 .line-thin{
  font-weight:300;font-style:italic;color:var(--t2);
  -webkit-text-fill-color:var(--t2);
}

.hero-desc{
  font-size:1rem;color:var(--t2);line-height:1.76;
  max-width:440px;margin-bottom:36px;
  animation:fadeSlideUp 0.6s ease 0.18s both;
}

.hero-btns{
  display:flex;gap:12px;flex-wrap:wrap;
  animation:fadeSlideUp 0.6s ease 0.26s both;
}
.btn-primary{
  display:inline-flex;align-items:center;gap:8px;
  padding:14px 28px;border-radius:12px;
  background:var(--teal);color:#000;
  font-size:0.88rem;font-weight:700;
  font-family:var(--f-body);border:none;cursor:pointer;
  transition:all 0.25s var(--ease-spring);text-decoration:none;
  box-shadow:0 4px 24px rgba(0,212,180,0.3);
}
.btn-primary:hover{transform:translateY(-3px);box-shadow:0 8px 36px rgba(0,212,180,0.4);background:white}
.btn-primary svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2.5}

.btn-secondary{
  display:inline-flex;align-items:center;gap:8px;
  padding:14px 28px;border-radius:12px;
  background:var(--glass);color:var(--t1);
  font-size:0.88rem;font-weight:500;
  font-family:var(--f-body);
  border:1px solid var(--rim);cursor:pointer;
  transition:all 0.22s;text-decoration:none;
}
.btn-secondary:hover{background:rgba(255,255,255,0.08);border-color:var(--rim2);transform:translateY(-2px)}
.btn-secondary svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2}

/* Hero stats */
.hero-metrics{
  display:flex;gap:28px;margin-top:44px;padding-top:36px;
  border-top:1px solid var(--rim);
  animation:fadeSlideUp 0.6s ease 0.34s both;
}
.hm-item{}
.hm-num{
  font-family:var(--f-display);font-size:2rem;font-weight:800;
  letter-spacing:-0.04em;line-height:1;color:var(--t1);
}
.hm-num em{color:var(--teal);font-style:normal}
.hm-label{font-size:0.7rem;color:var(--t3);margin-top:5px;letter-spacing:0.06em;text-transform:uppercase;font-weight:500}

/* ??? HERO RIGHT: 3D CARD STACK ??? */
.hero-visual{
  position:relative;height:520px;
  animation:fadeSlideUp 0.6s ease 0.2s both;
}

/* Main Dashboard Card */
.dash-card{
  position:absolute;top:50%;left:50%;
  transform:translate(-50%,-50%) perspective(1000px) rotateX(4deg) rotateY(-8deg);
  width:340px;
  background:var(--panel);
  border:1px solid var(--rim);border-radius:24px;
  overflow:hidden;
  box-shadow:
    0 40px 80px rgba(0,0,0,0.6),
    0 0 0 1px rgba(255,255,255,0.05),
    inset 0 1px 0 rgba(255,255,255,0.06);
  transition:transform 0.4s var(--ease-smooth);
  animation:cardFloat 8s ease-in-out infinite;
}
.dash-card:hover{transform:translate(-50%,-50%) perspective(1000px) rotateX(0deg) rotateY(0deg)}
@keyframes cardFloat{
  0%,100%{transform:translate(-50%,-50%) perspective(1000px) rotateX(4deg) rotateY(-8deg) translateY(0)}
  50%{transform:translate(-50%,-50%) perspective(1000px) rotateX(4deg) rotateY(-8deg) translateY(-12px)}
}

.dash-top{
  background:linear-gradient(135deg,rgba(0,212,180,0.12),rgba(14,165,233,0.08));
  padding:18px 20px;border-bottom:1px solid var(--rim);
  display:flex;align-items:center;justify-content:space-between;
}
.dash-title{font-family:var(--f-display);font-size:0.82rem;font-weight:700;color:var(--t1)}
.dash-status{
  display:flex;align-items:center;gap:6px;
  font-size:0.65rem;color:var(--teal);font-family:var(--f-mono);
}
.dash-body{padding:20px}

/* Health Score Ring */
.score-ring-wrap{display:flex;align-items:center;gap:16px;margin-bottom:18px}
.score-ring{position:relative;width:80px;height:80px;flex-shrink:0}
.ring-svg-main{transform:rotate(-90deg);width:80px;height:80px}
.ring-bg{fill:none;stroke:rgba(255,255,255,0.05);stroke-width:6}
.ring-progress{
  fill:none;stroke:url(#tealGrad);stroke-width:6;
  stroke-linecap:round;
  stroke-dasharray:220;stroke-dashoffset:220;
  animation:ringFill 2s cubic-bezier(0.25,0,0,1) 0.8s forwards;
}
@keyframes ringFill{to{stroke-dashoffset:44}}
.ring-label{
  position:absolute;inset:0;display:flex;flex-direction:column;
  align-items:center;justify-content:center;
}
.ring-num{font-family:var(--f-display);font-size:1.3rem;font-weight:800;color:var(--t1)}
.ring-sub{font-size:0.5rem;color:var(--t3);font-family:var(--f-mono);letter-spacing:0.06em;margin-top:1px}

.score-info{}
.score-big{font-family:var(--f-display);font-size:1.1rem;font-weight:700;color:var(--t1);line-height:1}
.score-tag{
  display:inline-block;padding:2px 8px;border-radius:100px;
  background:rgba(132,204,22,0.12);color:var(--lime);
  font-size:0.62rem;font-weight:600;margin-top:4px;font-family:var(--f-mono);
}
.score-note{font-size:0.7rem;color:var(--t3);margin-top:5px;line-height:1.4}

/* Vital signs mini chart */
.vitals{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-bottom:16px}
.vital{
  background:rgba(255,255,255,0.03);border:1px solid var(--rim2);
  border-radius:12px;padding:10px 12px;
}
.vital-label{font-size:0.6rem;color:var(--t3);font-family:var(--f-mono);letter-spacing:0.06em;margin-bottom:4px}
.vital-value{font-family:var(--f-display);font-size:0.95rem;font-weight:700;color:var(--t1)}
.vital-unit{font-size:0.58rem;color:var(--t3);margin-left:2px}
.vital-trend{
  display:inline-flex;align-items:center;gap:3px;
  font-size:0.6rem;margin-top:3px;
}
.trend-up{color:var(--lime)}
.trend-dn{color:var(--rose)}

/* Mini sparkline */
.sparkline{margin-top:5px}
.spark-path{stroke:var(--teal);fill:none;stroke-width:1.5;stroke-linecap:round;stroke-linejoin:round}
.spark-area{fill:url(#sparkGrad);opacity:0.3}

/* Next appt strip */
.appt-strip{
  background:linear-gradient(135deg,rgba(0,212,180,0.08),rgba(14,165,233,0.06));
  border:1px solid rgba(0,212,180,0.15);
  border-radius:12px;padding:12px 14px;
  display:flex;align-items:center;gap:12px;
}
.appt-icon{
  width:36px;height:36px;border-radius:9px;
  background:rgba(0,212,180,0.12);
  display:flex;align-items:center;justify-content:center;flex-shrink:0;
}
.appt-icon svg{width:16px;height:16px;stroke:var(--teal);fill:none;stroke-width:2}
.appt-info{}
.appt-title{font-size:0.75rem;font-weight:700;color:var(--t1)}
.appt-sub{font-size:0.65rem;color:var(--t3);margin-top:1px}
.appt-time{
  margin-left:auto;font-family:var(--f-mono);
  font-size:0.68rem;color:var(--teal);font-weight:500;
}

/* Floating badges around card */
.f-badge{
  position:absolute;
  background:rgba(11,16,24,0.92);
  border:1px solid var(--rim);border-radius:14px;
  padding:10px 14px;backdrop-filter:blur(12px);
  box-shadow:0 8px 32px rgba(0,0,0,0.4);
  display:flex;align-items:center;gap:10px;
}
.badge-1{top:30px;left:-30px;animation:badgeFloat 6s ease-in-out infinite}
.badge-2{bottom:60px;right:-40px;animation:badgeFloat 7s ease-in-out infinite reverse 1s}
.badge-3{top:160px;right:-50px;animation:badgeFloat 9s ease-in-out infinite 2s}
@keyframes badgeFloat{
  0%,100%{transform:translateY(0)}
  50%{transform:translateY(-8px)}
}
.fb-ico{
  width:32px;height:32px;border-radius:9px;
  display:flex;align-items:center;justify-content:center;font-size:1rem;
}
.fb-label{font-size:0.62rem;color:var(--t3)}
.fb-value{font-size:0.8rem;font-weight:700;color:var(--t1);font-family:var(--f-display)}

/* ???????????????????????????????????????????????
   SECTION BASE
??????????????????????????????????????????????? */
.section{padding:100px 0;position:relative}

.eyebrow{
  display:inline-flex;align-items:center;gap:10px;
  font-family:var(--f-mono);font-size:0.68rem;
  font-weight:500;color:var(--teal);letter-spacing:0.12em;
  text-transform:uppercase;margin-bottom:16px;
}
.eyebrow::before{content:'//';opacity:0.5;margin-right:2px}

.section-title{
  font-family:var(--f-display);
  font-size:clamp(2rem,4vw,3.2rem);
  font-weight:800;letter-spacing:-0.04em;
  line-height:1.05;color:var(--t1);
  margin-bottom:16px;
}
.section-title .hi{
  background:linear-gradient(90deg,var(--teal),var(--blue));
  -webkit-background-clip:text;-webkit-text-fill-color:transparent;
  background-clip:text;
}
.section-sub{font-size:0.95rem;color:var(--t2);line-height:1.76;max-width:520px}

/* ???????????????????????????????????????????????
   FEATURES ? BENTO GRID
??????????????????????????????????????????????? */
.features-section{background:var(--deep)}
.features-section::before{
  content:'';position:absolute;inset:0;pointer-events:none;
  background-image:radial-gradient(rgba(0,212,180,0.06) 1px,transparent 1px);
  background-size:32px 32px;
  mask-image:radial-gradient(ellipse 70% 80% at 50% 50%,black,transparent);
  -webkit-mask-image:radial-gradient(ellipse 70% 80% at 50% 50%,black,transparent);
}

.bento{
  display:grid;
  grid-template-columns:repeat(12,1fr);
  grid-template-rows:auto;
  gap:16px;
  margin-top:56px;
}

.bcard{
  background:var(--panel);
  border:1px solid var(--rim2);
  border-radius:20px;
  padding:28px;
  position:relative;overflow:hidden;
  transition:all 0.3s var(--ease-spring);
}
.bcard::before{
  content:'';position:absolute;inset:0;
  background:linear-gradient(135deg,rgba(0,212,180,0.03),transparent);
  opacity:0;transition:opacity 0.3s;border-radius:20px;
}
.bcard:hover{transform:translateY(-6px);border-color:rgba(0,212,180,0.2);box-shadow:0 20px 60px rgba(0,0,0,0.4),0 0 0 1px rgba(0,212,180,0.06)}
.bcard:hover::before{opacity:1}

/* Grid positions */
.bc1{grid-column:span 4}
.bc2{grid-column:span 4}
.bc3{grid-column:span 4}
.bc4{grid-column:span 5}
.bc5{grid-column:span 7}

.bcard-icon{
  width:48px;height:48px;border-radius:13px;
  display:flex;align-items:center;justify-content:center;
  margin-bottom:18px;transition:transform 0.3s var(--ease-spring);
  position:relative;
}
.bcard:hover .bcard-icon{transform:scale(1.1) rotate(-5deg)}
.bcard-icon svg{width:22px;height:22px;stroke:currentColor;fill:none;stroke-width:2}

.bcard-title{
  font-family:var(--f-display);font-size:1rem;font-weight:700;
  color:var(--t1);margin-bottom:10px;
}
.bcard-desc{font-size:0.83rem;color:var(--t2);line-height:1.65}
.bcard-link{
  display:inline-flex;align-items:center;gap:5px;
  margin-top:16px;font-size:0.78rem;font-weight:600;
  text-decoration:none;transition:gap 0.18s;
}
.bcard-link svg{width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2.5;transition:transform 0.18s}
.bcard-link:hover svg{transform:translateX(3px)}
.bcard-link:hover{gap:8px}

/* Wide card extras */
.bc5{display:flex;flex-direction:column}
.ai-demo{
  flex:1;margin-top:18px;
  background:rgba(255,255,255,0.02);border:1px solid var(--rim2);
  border-radius:13px;padding:14px;min-height:120px;
  display:flex;flex-direction:column;gap:8px;
}
.symptom-chip{
  display:inline-flex;align-items:center;gap:6px;
  padding:5px 12px;border-radius:100px;
  font-size:0.72rem;font-weight:500;font-family:var(--f-mono);
  border:1px solid;
}
.sc-red{background:rgba(244,63,94,0.08);border-color:rgba(244,63,94,0.2);color:#F87171}
.sc-amber{background:rgba(249,115,22,0.08);border-color:rgba(249,115,22,0.2);color:#FB923C}
.sc-green{background:rgba(132,204,22,0.08);border-color:rgba(132,204,22,0.2);color:#A3E635}
.ai-result{
  margin-top:6px;padding:10px 12px;
  background:rgba(0,212,180,0.06);
  border:1px solid rgba(0,212,180,0.15);
  border-radius:10px;font-size:0.72rem;color:var(--t2);
  display:flex;align-items:center;gap:8px;
}
.ai-result-dot{
  width:6px;height:6px;border-radius:50%;background:var(--teal);
  animation:pulse 2s ease-in-out infinite;flex-shrink:0;
}

/* ???????????????????????????????????????????????
   HOW IT WORKS ? HORIZONTAL TIMELINE
??????????????????????????????????????????????? */
.hiw-section{background:var(--void)}
.timeline{
  display:grid;grid-template-columns:repeat(4,1fr);
  gap:0;margin-top:64px;position:relative;
}
.timeline::before{
  content:'';position:absolute;
  top:30px;left:calc(12.5% + 16px);right:calc(12.5% + 16px);
  height:1px;background:linear-gradient(90deg,transparent,var(--teal),var(--blue),transparent);
}
.tl-item{
  padding:0 24px;position:relative;
  animation:fadeSlideUp 0.5s ease both;
}
.tl-item:nth-child(1){animation-delay:0.05s}
.tl-item:nth-child(2){animation-delay:0.15s}
.tl-item:nth-child(3){animation-delay:0.25s}
.tl-item:nth-child(4){animation-delay:0.35s}

.tl-num{
  width:60px;height:60px;border-radius:16px;
  background:linear-gradient(135deg,var(--teal),var(--blue));
  display:flex;align-items:center;justify-content:center;
  font-family:var(--f-mono);font-size:1rem;font-weight:700;color:#000;
  margin-bottom:24px;position:relative;
  box-shadow:0 8px 24px rgba(0,212,180,0.25);
  transition:transform 0.3s var(--ease-spring);
}
.tl-num:hover{transform:scale(1.1) rotate(-5deg)}
.tl-num::after{
  content:'';position:absolute;inset:-4px;
  border-radius:20px;border:1px solid rgba(0,212,180,0.2);
}
.tl-title{font-family:var(--f-display);font-size:1rem;font-weight:700;color:var(--t1);margin-bottom:10px}
.tl-desc{font-size:0.82rem;color:var(--t2);line-height:1.66}

/* ???????????????????????????????????????????????
   APPOINTMENT BOOKING SECTION
??????????????????????????????????????????????? */
.booking-section{
  background:var(--deep);
  position:relative;overflow:hidden;
}
.booking-section::before{
  content:'';position:absolute;top:-200px;left:-200px;
  width:600px;height:600px;border-radius:50%;
  background:radial-gradient(circle,rgba(0,212,180,0.06),transparent 70%);
  pointer-events:none;
}

.booking-grid{display:grid;grid-template-columns:1fr 1fr;gap:64px;align-items:center}

.booking-card{
  background:var(--panel);border:1px solid var(--rim);
  border-radius:24px;overflow:hidden;
  box-shadow:0 40px 80px rgba(0,0,0,0.5);
}
.bc-head{
  padding:20px 24px;
  background:linear-gradient(135deg,rgba(0,212,180,0.1),rgba(14,165,233,0.06));
  border-bottom:1px solid var(--rim);
  display:flex;align-items:center;justify-content:space-between;
}
.bc-head-title{font-family:var(--f-display);font-size:0.9rem;font-weight:700;color:var(--t1)}
.bc-avail{
  padding:4px 10px;border-radius:100px;
  font-size:0.65rem;font-weight:600;font-family:var(--f-mono);
  background:rgba(132,204,22,0.1);color:var(--lime);
  border:1px solid rgba(132,204,22,0.2);
}
.bc-body{padding:20px 24px}

.doc-list{display:flex;flex-direction:column;gap:8px;margin-bottom:20px}
.doc-item{
  display:flex;align-items:center;gap:12px;
  padding:12px;border-radius:12px;
  border:1px solid var(--rim2);background:var(--glass);
  cursor:pointer;transition:all 0.18s;
}
.doc-item:hover,.doc-item.sel{
  border-color:rgba(0,212,180,0.3);
  background:rgba(0,212,180,0.05);
}
.doc-av{
  width:42px;height:42px;border-radius:11px;
  display:flex;align-items:center;justify-content:center;
  font-size:1.2rem;flex-shrink:0;
}
.doc-name{font-size:0.83rem;font-weight:700;color:var(--t1)}
.doc-spec{font-size:0.68rem;color:var(--t3);margin-top:2px}
.doc-rating{margin-left:auto;font-size:0.72rem;font-weight:700;color:var(--teal);font-family:var(--f-mono)}

.slots-label{font-size:0.65rem;font-weight:600;color:var(--t3);font-family:var(--f-mono);letter-spacing:0.1em;text-transform:uppercase;margin-bottom:10px}
.slots{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-bottom:16px}
.slot{
  padding:9px 4px;border-radius:10px;
  border:1px solid var(--rim2);text-align:center;
  font-size:0.73rem;font-weight:600;color:var(--t3);
  cursor:pointer;transition:all 0.18s var(--ease-spring);
  font-family:var(--f-mono);background:var(--glass);
}
.slot:hover,.slot.active{
  border-color:var(--teal);color:var(--teal);
  background:rgba(0,212,180,0.08);transform:scale(1.03);
}
.btn-book{
  width:100%;padding:13px;border-radius:12px;
  background:linear-gradient(135deg,var(--teal),var(--teal2));
  color:#000;font-family:var(--f-body);font-weight:700;font-size:0.85rem;
  border:none;cursor:pointer;transition:all 0.22s var(--ease-spring);
  display:flex;align-items:center;justify-content:center;gap:8px;
  box-shadow:0 4px 20px rgba(0,212,180,0.25);
}
.btn-book:hover{transform:translateY(-2px);box-shadow:0 8px 28px rgba(0,212,180,0.35)}
.btn-book svg{width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:2.5}

/* ???????????????????????????????????????????????
   STATS BAR
??????????????????????????????????????????????? */
.stats-bar{
  background:var(--void);border-top:1px solid var(--rim);border-bottom:1px solid var(--rim);
  padding:48px 0;
}
.stats-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:0}
.stat-item{
  text-align:center;padding:0 32px;
  border-right:1px solid var(--rim);
}
.stat-item:last-child{border-right:none}
.stat-num{
  font-family:var(--f-display);font-size:2.8rem;font-weight:800;
  letter-spacing:-0.04em;color:var(--t1);line-height:1;
}
.stat-num em{color:var(--teal);font-style:normal}
.stat-label{font-size:0.72rem;color:var(--t3);margin-top:8px;letter-spacing:0.08em;text-transform:uppercase;font-weight:500}
.stat-sub{font-size:0.75rem;color:var(--t2);margin-top:4px}

/* ???????????????????????????????????????????????
   TESTIMONIALS
??????????????????????????????????????????????? */
.testi-section{background:var(--deep)}
.testi-grid{
  display:grid;grid-template-columns:repeat(3,1fr);
  gap:16px;margin-top:56px;
}
.tcard{
  background:var(--panel);border:1px solid var(--rim2);
  border-radius:20px;padding:28px;
  transition:all 0.3s var(--ease-spring);position:relative;overflow:hidden;
}
.tcard::before{
  content:'';position:absolute;top:0;left:0;right:0;height:2px;
  background:linear-gradient(90deg,transparent,var(--teal),transparent);
  opacity:0;transition:opacity 0.3s;
}
.tcard:hover{transform:translateY(-6px);border-color:rgba(0,212,180,0.15);box-shadow:0 20px 50px rgba(0,0,0,0.4)}
.tcard:hover::before{opacity:1}

.tcard-stars{
  display:flex;gap:3px;margin-bottom:16px;
}
.star{
  width:14px;height:14px;
  background:#F59E0B;clip-path:polygon(50% 0%,61% 35%,98% 35%,68% 57%,79% 91%,50% 70%,21% 91%,32% 57%,2% 35%,39% 35%);
}
.tcard-quote{
  font-size:0.875rem;color:var(--t2);line-height:1.74;
  margin-bottom:20px;font-style:italic;
}
.tcard-author{display:flex;align-items:center;gap:10px}
.tcard-av{
  width:38px;height:38px;border-radius:10px;
  display:flex;align-items:center;justify-content:center;
  font-size:1.1rem;
}
.tcard-name{font-size:0.83rem;font-weight:700;color:var(--t1)}
.tcard-role{font-size:0.67rem;color:var(--t3);margin-top:1px}

/* ???????????????????????????????????????????????
   CTA BANNER
??????????????????????????????????????????????? */
.cta-section{padding:100px 0;background:var(--void)}
.cta-box{
  border-radius:28px;overflow:hidden;
  position:relative;
  background:linear-gradient(135deg,#051a14 0%,#072a20 40%,#0a1f2e 100%);
  border:1px solid rgba(0,212,180,0.15);
  padding:72px 64px;
  box-shadow:0 40px 100px rgba(0,0,0,0.5),0 0 0 1px rgba(0,212,180,0.05);
}
.cta-box::before{
  content:'';position:absolute;inset:0;pointer-events:none;
  background-image:
    repeating-linear-gradient(0deg,rgba(0,212,180,0.03) 0px,rgba(0,212,180,0.03) 1px,transparent 1px,transparent 40px),
    repeating-linear-gradient(90deg,rgba(0,212,180,0.03) 0px,rgba(0,212,180,0.03) 1px,transparent 1px,transparent 40px);
}
.cta-box::after{
  content:'';position:absolute;right:-100px;top:-100px;
  width:400px;height:400px;border-radius:50%;pointer-events:none;
  background:radial-gradient(circle,rgba(0,212,180,0.08),transparent 70%);
}
.cta-inner{display:grid;grid-template-columns:1fr auto;gap:40px;align-items:center;position:relative;z-index:1}
.cta-title{
  font-family:var(--f-display);font-size:clamp(1.8rem,3vw,2.5rem);
  font-weight:800;letter-spacing:-0.04em;color:var(--t1);margin-bottom:12px;
}
.cta-desc{font-size:0.95rem;color:rgba(255,255,255,0.55);line-height:1.7}
.cta-btns{display:flex;flex-direction:column;gap:10px;align-items:flex-end;flex-shrink:0}
.btn-cta-main{
  display:inline-flex;align-items:center;gap:8px;
  padding:14px 28px;border-radius:12px;
  background:white;color:#000;
  font-size:0.88rem;font-weight:700;
  font-family:var(--f-body);border:none;cursor:pointer;
  transition:all 0.25s var(--ease-spring);text-decoration:none;
  box-shadow:0 4px 20px rgba(255,255,255,0.1);white-space:nowrap;
}
.btn-cta-main:hover{background:var(--teal);transform:translateY(-2px);box-shadow:0 8px 28px rgba(0,212,180,0.3)}
.btn-cta-main svg{width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:2.5}
.btn-cta-ghost{
  display:inline-flex;align-items:center;gap:8px;
  padding:12px 24px;border-radius:12px;
  background:rgba(255,255,255,0.06);color:rgba(255,255,255,0.7);
  font-size:0.85rem;font-weight:500;
  font-family:var(--f-body);border:1px solid rgba(255,255,255,0.1);cursor:pointer;
  transition:all 0.22s;text-decoration:none;white-space:nowrap;
}
.btn-cta-ghost:hover{background:rgba(255,255,255,0.1);color:white}
.btn-cta-ghost svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2}

/* ???????????????????????????????????????????????
   FOOTER
??????????????????????????????????????????????? */
.footer{
  background:var(--void);
  border-top:1px solid var(--rim);
  padding:64px 0 28px;
}
.footer-grid{
  display:grid;grid-template-columns:2fr 1fr 1fr 1fr;
  gap:48px;margin-bottom:48px;
}
.footer-brand .logo-name{font-family:var(--f-display);font-weight:700;font-size:1.05rem;color:var(--t1)}
.footer-brand .logo-name em{color:var(--teal);font-style:normal}
.footer-desc{font-size:0.82rem;color:var(--t3);line-height:1.72;max-width:240px;margin-top:14px}

.footer-col-title{
  font-family:var(--f-mono);font-size:0.65rem;font-weight:500;
  color:var(--t3);letter-spacing:0.12em;text-transform:uppercase;margin-bottom:18px;
}
.footer-links{list-style:none;display:flex;flex-direction:column;gap:11px}
.footer-links a{font-size:0.82rem;color:var(--t2);text-decoration:none;transition:color 0.18s}
.footer-links a:hover{color:var(--teal)}

.footer-bottom{
  display:flex;align-items:center;justify-content:space-between;
  padding-top:24px;border-top:1px solid var(--rim);
}
.footer-copy{font-size:0.76rem;color:var(--t3)}
.social-links{display:flex;gap:8px}
.soc-btn{
  width:32px;height:32px;border-radius:9px;
  background:var(--glass);border:1px solid var(--rim2);
  display:flex;align-items:center;justify-content:center;
  color:var(--t3);text-decoration:none;transition:all 0.2s var(--ease-spring);
}
.soc-btn:hover{background:rgba(0,212,180,0.1);border-color:rgba(0,212,180,0.2);color:var(--teal);transform:translateY(-2px)}
.soc-btn svg{width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2}

/* ???????????????????????????????????????????????
   MODAL
??????????????????????????????????????????????? */
.modal-overlay{
  position:fixed;inset:0;
  background:rgba(3,5,8,0.88);
  backdrop-filter:blur(12px);-webkit-backdrop-filter:blur(12px);
  z-index:2000;display:flex;align-items:center;justify-content:center;
  padding:20px;opacity:0;pointer-events:none;
  transition:opacity 0.25s;
}
.modal-overlay.show{opacity:1;pointer-events:all}
.modal-box{
  background:var(--panel);border:1px solid var(--rim);
  border-radius:28px;max-width:440px;width:100%;
  overflow:hidden;
  box-shadow:0 50px 120px rgba(0,0,0,0.7),0 0 0 1px rgba(0,212,180,0.06);
  transform:scale(0.94) translateY(16px);
  transition:transform 0.3s var(--ease-spring);
}
.modal-overlay.show .modal-box{transform:scale(1) translateY(0)}

.modal-head{
  padding:24px 26px;
  background:linear-gradient(135deg,rgba(0,212,180,0.1),rgba(14,165,233,0.07));
  border-bottom:1px solid var(--rim);
  display:flex;align-items:center;justify-content:space-between;
}
.modal-title{
  font-family:var(--f-display);font-size:1.05rem;font-weight:700;
  color:var(--t1);display:flex;align-items:center;gap:10px;
}
.modal-title svg{width:18px;height:18px;stroke:var(--teal);fill:none;stroke-width:2.5}
.modal-close{
  width:32px;height:32px;border-radius:8px;
  background:var(--glass);border:1px solid var(--rim);
  cursor:pointer;color:var(--t2);
  display:flex;align-items:center;justify-content:center;
  transition:all 0.2s var(--ease-spring);
}
.modal-close:hover{background:rgba(244,63,94,0.1);border-color:rgba(244,63,94,0.2);color:var(--rose);transform:rotate(90deg)}
.modal-close svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2.5}

.modal-body{padding:28px}
.modal-hint{text-align:center;font-size:0.82rem;color:var(--t3);margin-bottom:22px}

.role-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.role-card{
  display:block;text-decoration:none;
  background:var(--glass);border:1px solid var(--rim2);
  border-radius:18px;padding:24px 16px;text-align:center;
  transition:all 0.28s var(--ease-spring);position:relative;overflow:hidden;
}
.role-card:hover{transform:translateY(-5px)}
.role-card.rp:hover{border-color:rgba(0,212,180,0.35);background:rgba(0,212,180,0.06);box-shadow:0 12px 32px rgba(0,0,0,0.3)}
.role-card.rd:hover{border-color:rgba(14,165,233,0.35);background:rgba(14,165,233,0.06);box-shadow:0 12px 32px rgba(0,0,0,0.3)}

.role-ico{
  width:56px;height:56px;border-radius:15px;
  display:flex;align-items:center;justify-content:center;
  margin:0 auto 12px;transition:transform 0.28s var(--ease-spring);
}
.rp .role-ico{background:linear-gradient(135deg,rgba(0,212,180,0.2),rgba(0,168,150,0.1));color:var(--teal)}
.rd .role-ico{background:linear-gradient(135deg,rgba(14,165,233,0.2),rgba(14,165,233,0.1));color:var(--blue)}
.role-card:hover .role-ico{transform:scale(1.1) rotate(-6deg)}
.role-ico svg{width:26px;height:26px;stroke:currentColor;fill:none;stroke-width:2}

.role-name{font-family:var(--f-display);font-weight:700;font-size:0.94rem;color:var(--t1);margin-bottom:5px}
.role-desc{font-size:0.7rem;color:var(--t3);line-height:1.5}
.role-badge{
  display:inline-block;margin-top:10px;padding:3px 10px;
  border-radius:100px;font-size:0.63rem;font-weight:600;font-family:var(--f-mono);
}
.rp .role-badge{background:rgba(0,212,180,0.1);color:var(--teal)}
.rd .role-badge{background:rgba(14,165,233,0.1);color:var(--blue)}

.modal-divider{
  display:flex;align-items:center;gap:12px;
  margin:20px 0 16px;font-size:0.68rem;color:var(--t3);
  font-family:var(--f-mono);letter-spacing:0.08em;text-transform:uppercase;
}
.modal-divider::before,.modal-divider::after{content:'';flex:1;height:1px;background:var(--rim2)}

.modal-login-links{
  text-align:center;font-size:0.8rem;color:var(--t3);
}
.modal-login-links a{font-weight:600;text-decoration:none;transition:color 0.15s}
.modal-login-links a.lp{color:var(--teal)}
.modal-login-links a.ld{color:var(--blue)}
.modal-login-links a:hover{text-decoration:underline}
.modal-login-links span{margin:0 10px;opacity:0.3}

/* ???????????????????????????????????????????????
   ANIMATIONS
??????????????????????????????????????????????? */
@keyframes fadeSlideUp{
  from{opacity:0;transform:translateY(24px)}
  to{opacity:1;transform:translateY(0)}
}
.reveal{transition:opacity 0.6s ease,transform 0.6s ease}
.reveal.hidden{opacity:0;transform:translateY(28px)}
.reveal.visible{opacity:1;transform:translateY(0)}

/* ???????????????????????????????????????????????
   RESPONSIVE
??????????????????????????????????????????????? */
@media(max-width:991px){
  .nav-links{display:none}
  .hero-inner{grid-template-columns:1fr;text-align:center}
  .hero-visual{height:380px}
  .dash-card{width:280px}
  .hero-desc{margin:0 auto 36px}
  .hero-metrics{justify-content:center}
  .bento{grid-template-columns:1fr 1fr}
  .bc1,.bc2,.bc3,.bc4,.bc5{grid-column:span 2}
  .timeline{grid-template-columns:1fr 1fr;gap:32px}
  .booking-grid{grid-template-columns:1fr}
  .stats-grid{grid-template-columns:repeat(2,1fr)}
  .stat-item{border-bottom:1px solid var(--rim);border-right:none}
  .stat-item:nth-child(1),.stat-item:nth-child(2){border-right:1px solid var(--rim)}
  .testi-grid{grid-template-columns:1fr}
  .cta-inner{grid-template-columns:1fr}
  .cta-btns{flex-direction:row;align-items:flex-start}
  .footer-grid{grid-template-columns:1fr 1fr}
  .badge-1,.badge-2,.badge-3{display:none}
}
@media(max-width:600px){
  .timeline{grid-template-columns:1fr}
  .bento{grid-template-columns:1fr}
  .bc1,.bc2,.bc3,.bc4,.bc5{grid-column:span 1}
  .stats-grid{grid-template-columns:1fr 1fr}
  .cta-box{padding:36px 24px}
  .footer-grid{grid-template-columns:1fr}
  .hero-metrics{flex-wrap:wrap;gap:16px}
}
</style>
</head>
<body>

<!-- Cursor -->
<div id="cursor"></div>
<div id="cursor-ring"></div>

<!-- Ambient -->
<div class="ambient"></div>

<!-- ??? NAVBAR ??? -->
<div class="nav-wrap">
  <div class="nav-inner">
    <a class="nav-logo" href="#">
      <div class="logo-mark">
        <svg class="logo-ecg" viewBox="0 0 22 14">
          <polyline points="0,7 4,7 6,2 8,12 10,4 12,10 14,7 22,7"/>
        </svg>
      </div>
      <span class="logo-name">HealthOS<sup>AI</sup></span>
    </a>

    <ul class="nav-links">
      <li><a href="#home" class="active">Home</a></li>
      <li><a href="#features">Features</a></li>
      <li class="nav-dd">
        <a href="#" style="display:flex;align-items:center;gap:5px">
          Patients
          <svg width="10" height="10" viewBox="0 0 10 10" fill="none" stroke="currentColor" stroke-width="2"><polyline points="2,3 5,7 8,3"/></svg>
        </a>
        <div class="nav-dd-menu">
          <a href="userLogin.jsp">
            <div class="dd-icon" style="background:rgba(0,212,180,0.1)">?</div>
            Patient Login
          </a>
          <a href="userRegister.jsp">
            <div class="dd-icon" style="background:rgba(0,212,180,0.08)">?</div>
            Register Now
          </a>
        </div>
      </li>
      <li class="nav-dd">
        <a href="#" style="display:flex;align-items:center;gap:5px">
          Doctors
          <svg width="10" height="10" viewBox="0 0 10 10" fill="none" stroke="currentColor" stroke-width="2"><polyline points="2,3 5,7 8,3"/></svg>
        </a>
        <div class="nav-dd-menu">
          <a href="doctorLogin.jsp">
            <div class="dd-icon" style="background:rgba(14,165,233,0.1)">?</div>
            Doctor Login
          </a>
          <a href="doctorRegister.jsp">
            <div class="dd-icon" style="background:rgba(14,165,233,0.08)">?</div>
            Join as Doctor
          </a>
        </div>
      </li>
      <li><a href="#about">About</a></li>
      <li><a href="#contact">Reviews</a></li>
    </ul>

    <div class="nav-cta">
      <a href="userLogin.jsp" class="btn-nav-ghost">Log in</a>
      <button class="btn-nav-primary" onclick="openModal()">
        Get Started
        <svg viewBox="0 0 14 14"><polyline points="3,7 11,7"/><polyline points="7,3 11,7 7,11"/></svg>
      </button>
    </div>
  </div>
</div>


<!-- ??? HERO ??? -->
<section class="hero" id="home">
  <div class="hero-grid">
    <div class="grid-plane"></div>
  </div>
  <div class="orb orb-a"></div>
  <div class="orb orb-b"></div>
  <div class="orb orb-c"></div>

  <div class="container">
    <div class="hero-inner">
      <div class="hero-left">
        <div class="hero-tag">
          <span class="pulse-dot"></span>
          v2.0 ? AI-Powered Platform
        </div>

        <h1 class="hero-h1">
          Healthcare<br>
          <span class="line-accent">Reimagined</span><br>
          <span class="line-thin">for the digital age</span>
        </h1>

        <p class="hero-desc">
          Book specialists, get AI-powered disease predictions with 98.2% accuracy, and manage your entire health journey ? beautifully, seamlessly, intelligently.
        </p>

        <div class="hero-btns">
          <button class="btn-primary" onclick="openModal()">
            <svg viewBox="0 0 16 16"><path d="M8 1v14M1 8h14" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"/></svg>
            Start for Free
          </button>
          <a href="#features" class="btn-secondary">
            <svg viewBox="0 0 16 16"><circle cx="8" cy="8" r="7"/><polyline points="6,5 11,8 6,11"/></svg>
            Watch Demo
          </a>
        </div>

        <div class="hero-metrics">
          <div class="hm-item">
            <div class="hm-num"><span class="counter" data-target="12">0</span>K<em>+</em></div>
            <div class="hm-label">Patients</div>
          </div>
          <div class="hm-item">
            <div class="hm-num"><span class="counter" data-target="480">0</span><em>+</em></div>
            <div class="hm-label">Specialists</div>
          </div>
          <div class="hm-item">
            <div class="hm-num"><span class="counter" data-target="98">0</span><em>%</em></div>
            <div class="hm-label">AI Accuracy</div>
          </div>
          <div class="hm-item">
            <div class="hm-num"><span class="counter" data-target="4">0</span>.<em>9?</em></div>
            <div class="hm-label">Rating</div>
          </div>
        </div>
      </div>

      <div class="hero-visual">
        <!-- Floating badges -->
        <div class="f-badge badge-1">
          <div class="fb-ico" style="background:rgba(132,204,22,0.1)">?</div>
          <div>
            <div class="fb-label">Appointment</div>
            <div class="fb-value">Confirmed</div>
          </div>
        </div>

        <div class="f-badge badge-2">
          <div class="fb-ico" style="background:rgba(14,165,233,0.1)">?</div>
          <div>
            <div class="fb-label">AI Analysis</div>
            <div class="fb-value">98.2% Acc.</div>
          </div>
        </div>

        <div class="f-badge badge-3">
          <div class="fb-ico" style="background:rgba(249,115,22,0.1)">?</div>
          <div>
            <div class="fb-label">Reminder</div>
            <div class="fb-value">10:30 AM</div>
          </div>
        </div>

        <!-- Main dashboard card -->
        <div class="dash-card">
          <svg style="position:absolute;width:0;height:0">
            <defs>
              <linearGradient id="tealGrad" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" stop-color="#00D4B4"/>
                <stop offset="100%" stop-color="#0EA5E9"/>
              </linearGradient>
              <linearGradient id="sparkGrad" x1="0%" y1="0%" x2="0%" y2="100%">
                <stop offset="0%" stop-color="#00D4B4" stop-opacity="0.4"/>
                <stop offset="100%" stop-color="#00D4B4" stop-opacity="0"/>
              </linearGradient>
            </defs>
          </svg>

          <div class="dash-top">
            <div class="dash-title">Health Dashboard</div>
            <div class="dash-status">
              <span style="width:6px;height:6px;border-radius:50%;background:#84CC16;display:inline-block;animation:pulse 2s infinite"></span>
              LIVE
            </div>
          </div>

          <div class="dash-body">
            <div class="score-ring-wrap">
              <div class="score-ring">
                <svg class="ring-svg-main" viewBox="0 0 80 80">
                  <circle class="ring-bg" cx="40" cy="40" r="35"/>
                  <circle class="ring-progress" cx="40" cy="40" r="35"/>
                </svg>
                <div class="ring-label">
                  <div class="ring-num">86</div>
                  <div class="ring-sub">SCORE</div>
                </div>
              </div>
              <div class="score-info">
                <div class="score-big">Health Score</div>
                <span class="score-tag">? EXCELLENT</span>
                <div class="score-note">Better than 79% of users<br>in your age group</div>
              </div>
            </div>

            <div class="vitals">
              <div class="vital">
                <div class="vital-label">HEART RATE</div>
                <div class="vital-value">72<span class="vital-unit">bpm</span></div>
                <div class="vital-trend trend-up">? Normal</div>
              </div>
              <div class="vital">
                <div class="vital-label">BLOOD PRESSURE</div>
                <div class="vital-value">120<span class="vital-unit">/80</span></div>
                <div class="vital-trend trend-up">? Optimal</div>
              </div>
              <div class="vital">
                <div class="vital-label">TEMPERATURE</div>
                <div class="vital-value">98.6<span class="vital-unit">캟</span></div>
                <div class="vital-trend trend-up">? Normal</div>
              </div>
              <div class="vital">
                <div class="vital-label">BLOOD SUGAR</div>
                <div class="vital-value">95<span class="vital-unit">mg/dL</span></div>
                <div class="vital-trend trend-up">? Good</div>
              </div>
            </div>

            <div class="appt-strip">
              <div class="appt-icon">
                <svg viewBox="0 0 16 16"><rect x="2" y="3" width="12" height="12" rx="2"/><path d="M11 1v4M5 1v4M2 8h12"/></svg>
              </div>
              <div class="appt-info">
                <div class="appt-title">Dr. Priya Sharma</div>
                <div class="appt-sub">Cardiology � Today</div>
              </div>
              <div class="appt-time">10:30</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>


<!-- ??? STATS BAR ??? -->
<div class="stats-bar">
  <div class="container">
    <div class="stats-grid">
      <div class="stat-item">
        <div class="stat-num"><span class="counter" data-target="12">0</span>K<em>+</em></div>
        <div class="stat-label">Patients Served</div>
        <div class="stat-sub">Across India</div>
      </div>
      <div class="stat-item">
        <div class="stat-num"><span class="counter" data-target="480">0</span><em>+</em></div>
        <div class="stat-label">Verified Specialists</div>
        <div class="stat-sub">40+ Specialties</div>
      </div>
      <div class="stat-item">
        <div class="stat-num"><span class="counter" data-target="98">0</span><em>%</em></div>
        <div class="stat-label">AI Accuracy</div>
        <div class="stat-sub">Clinically validated</div>
      </div>
      <div class="stat-item">
        <div class="stat-num"><span class="counter" data-target="60">0</span><em>s</em></div>
        <div class="stat-label">Avg. Booking Time</div>
        <div class="stat-sub">Fastest in India</div>
      </div>
    </div>
  </div>
</div>


<!-- ??? FEATURES ??? -->
<section class="section features-section" id="features">
  <div class="container" style="position:relative;z-index:1">
    <div class="eyebrow">What We Offer</div>
    <h2 class="section-title">Everything your health<br><span class="hi">needs, in one place</span></h2>
    <p class="section-sub">From AI-powered disease predictions to seamless specialist booking ? built for the future of healthcare.</p>

    <div class="bento">
      <div class="bcard bc1 reveal">
        <div class="bcard-icon" style="background:rgba(0,212,180,0.1);color:var(--teal)">
          <svg viewBox="0 0 22 22"><rect x="3" y="4" width="16" height="16" rx="2"/><path d="M16 2v4M8 2v4M3 10h16"/><path d="M8 14h2m2 0h2"/></svg>
        </div>
        <div class="bcard-title">Smart Booking</div>
        <div class="bcard-desc">Book any specialist in under 60 seconds. Real-time availability, smart matching, automatic reminders.</div>
        <a href="userRegister.jsp" class="bcard-link" style="color:var(--teal)">
          Book now
          <svg viewBox="0 0 13 13"><polyline points="2,6.5 11,6.5"/><polyline points="7,2.5 11,6.5 7,10.5"/></svg>
        </a>
      </div>

      <div class="bcard bc2 reveal">
        <div class="bcard-icon" style="background:rgba(14,165,233,0.1);color:var(--blue)">
          <svg viewBox="0 0 22 22"><path d="M21 16s-2-2-4-2-4 2-4 2"/><path d="M11 11.5a4 4 0 1 0 0-8 4 4 0 0 0 0 8z"/><path d="M3 20v-2a4 4 0 0 1 4-4h1"/></svg>
        </div>
        <div class="bcard-title">AI Prediction</div>
        <div class="bcard-desc">Advanced ML models analyse your symptoms with 98.2% clinical accuracy. Early detection saves lives.</div>
        <a href="userRegister.jsp" class="bcard-link" style="color:var(--blue)">
          Try now
          <svg viewBox="0 0 13 13"><polyline points="2,6.5 11,6.5"/><polyline points="7,2.5 11,6.5 7,10.5"/></svg>
        </a>
      </div>

      <div class="bcard bc3 reveal">
        <div class="bcard-icon" style="background:rgba(249,115,22,0.1);color:var(--ember)">
          <svg viewBox="0 0 22 22"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        </div>
        <div class="bcard-title">Secure Payments</div>
        <div class="bcard-desc">Bank-grade 256-bit encryption on every transaction. Instant digital receipts, full refund protection.</div>
        <a href="userRegister.jsp" class="bcard-link" style="color:var(--ember)">
          Learn more
          <svg viewBox="0 0 13 13"><polyline points="2,6.5 11,6.5"/><polyline points="7,2.5 11,6.5 7,10.5"/></svg>
        </a>
      </div>

      <!-- Wide card with AI demo -->
      <div class="bcard bc5 reveal">
        <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:12px">
          <div>
            <div class="bcard-icon" style="background:rgba(124,58,237,0.1);color:#A78BFA;margin-bottom:12px">
              <svg viewBox="0 0 22 22"><path d="M12 2a5 5 0 1 0 0 10 5 5 0 0 0 0-10z"/><path d="M12 14c-7 0-9 3.5-9 5.5V21h18v-1.5C21 17.5 19 14 12 14z" opacity=".4"/><path d="M17 8l2 2-4 4-2-2"/></svg>
            </div>
            <div class="bcard-title">AI Symptom Analysis</div>
            <div class="bcard-desc">Describe symptoms, get instant AI-driven risk assessment with specialist recommendations.</div>
          </div>
          <div style="flex-shrink:0;padding:6px 12px;border-radius:100px;background:rgba(124,58,237,0.1);border:1px solid rgba(124,58,237,0.2);font-size:0.65rem;color:#A78BFA;font-family:var(--f-mono);white-space:nowrap">ML v3.1</div>
        </div>
        <div class="ai-demo">
          <div style="font-size:0.68rem;color:var(--t3);font-family:var(--f-mono);margin-bottom:4px">// Detected symptoms</div>
          <div style="display:flex;flex-wrap:wrap;gap:6px">
            <span class="symptom-chip sc-red">? Chest tightness</span>
            <span class="symptom-chip sc-amber">? Mild fatigue</span>
            <span class="symptom-chip sc-amber">? Shortness of breath</span>
            <span class="symptom-chip sc-green">? No fever</span>
          </div>
          <div class="ai-result">
            <span class="ai-result-dot"></span>
            <span>Analysis complete ? <strong style="color:var(--teal)">Cardiology consult recommended.</strong> Risk: Moderate. Early intervention advised.</span>
          </div>
        </div>
        <a href="userRegister.jsp" class="bcard-link" style="color:#A78BFA">
          Try AI prediction
          <svg viewBox="0 0 13 13"><polyline points="2,6.5 11,6.5"/><polyline points="7,2.5 11,6.5 7,10.5"/></svg>
        </a>
      </div>

      <div class="bcard bc4 reveal">
        <div class="bcard-icon" style="background:rgba(244,63,94,0.08);color:var(--rose)">
          <svg viewBox="0 0 22 22"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
        </div>
        <div class="bcard-title">Digital Health Records</div>
        <div class="bcard-desc">Your complete medical history, prescriptions, lab reports ? all in one secure, shareable place. Lifetime access.</div>
        <a href="userRegister.jsp" class="bcard-link" style="color:var(--rose)">
          Get started
          <svg viewBox="0 0 13 13"><polyline points="2,6.5 11,6.5"/><polyline points="7,2.5 11,6.5 7,10.5"/></svg>
        </a>
      </div>

      <div class="bcard bc1 reveal">
        <div class="bcard-icon" style="background:rgba(132,204,22,0.08);color:var(--lime)">
          <svg viewBox="0 0 22 22"><path d="M15 10l-4 4-4-4"/><path d="M11 14V3"/><path d="M19 19H5"/></svg>
        </div>
        <div class="bcard-title">Video Consult</div>
        <div class="bcard-desc">HD encrypted video calls with doctors. In-call prescriptions, notes, and follow-up scheduling built right in.</div>
        <a href="userRegister.jsp" class="bcard-link" style="color:var(--lime)">
          Start call
          <svg viewBox="0 0 13 13"><polyline points="2,6.5 11,6.5"/><polyline points="7,2.5 11,6.5 7,10.5"/></svg>
        </a>
      </div>

      <div class="bcard bc2 reveal">
        <div class="bcard-icon" style="background:rgba(0,168,150,0.1);color:var(--teal2)">
          <svg viewBox="0 0 22 22"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
        </div>
        <div class="bcard-title">Smart Reminders</div>
        <div class="bcard-desc">Intelligent alerts for medications, follow-ups, and annual check-ups. Personalised wellness tips daily.</div>
        <a href="userRegister.jsp" class="bcard-link" style="color:var(--teal2)">
          Enable
          <svg viewBox="0 0 13 13"><polyline points="2,6.5 11,6.5"/><polyline points="7,2.5 11,6.5 7,10.5"/></svg>
        </a>
      </div>
    </div>
  </div>
</section>


<!-- ??? HOW IT WORKS ??? -->
<section class="section hiw-section" id="about">
  <div class="container">
    <div style="text-align:center;margin-bottom:0">
      <div class="eyebrow">How It Works</div>
      <h2 class="section-title">From signup to<br><span class="hi">feeling better</span></h2>
      <p class="section-sub" style="margin:0 auto">Four simple steps. Designed to be fast, intuitive, and stress-free from day one.</p>
    </div>

    <div class="timeline">
      <div class="tl-item reveal">
        <div class="tl-num">01</div>
        <div class="tl-title">Create Your Profile</div>
        <div class="tl-desc">Sign up in seconds. Add your medical history, allergies, and preferences for a truly personalised experience that gets smarter over time.</div>
      </div>
      <div class="tl-item reveal">
        <div class="tl-num">02</div>
        <div class="tl-title">Describe Symptoms</div>
        <div class="tl-desc">Tell our AI what you're feeling. Get instant risk assessment, smart doctor matching, and personalised health insights within moments.</div>
      </div>
      <div class="tl-item reveal">
        <div class="tl-num">03</div>
        <div class="tl-title">Book Appointment</div>
        <div class="tl-desc">Browse verified specialists, check live availability, choose a time slot, and confirm with secure online payment ? all in under 60 seconds.</div>
      </div>
      <div class="tl-item reveal">
        <div class="tl-num">04</div>
        <div class="tl-title">Get Better</div>
        <div class="tl-desc">Receive digital prescriptions, track your recovery, and stay on top of follow-ups with smart reminders. Your full journey, simplified.</div>
      </div>
    </div>
  </div>
</section>


<!-- ??? BOOKING SECTION ??? -->
<section class="section booking-section">
  <div class="container" style="position:relative;z-index:1">
    <div class="booking-grid">
      <div>
        <div class="eyebrow">Book a Specialist</div>
        <h2 class="section-title">The easiest<br><span class="hi">appointment</span><br>you'll ever book</h2>
        <p class="section-sub" style="margin-bottom:28px">Choose from 480+ verified specialists across 40+ specialties. Real-time availability, no phone calls required.</p>
        <div style="display:flex;flex-direction:column;gap:14px">
          <div style="display:flex;align-items:center;gap:12px">
            <div style="width:36px;height:36px;border-radius:9px;background:rgba(0,212,180,0.1);border:1px solid rgba(0,212,180,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="var(--teal)" stroke-width="2" stroke-linecap="round"><polyline points="3,8 6,11 13,5"/></svg>
            </div>
            <span style="font-size:0.85rem;color:var(--t2)">480+ verified specialists across India</span>
          </div>
          <div style="display:flex;align-items:center;gap:12px">
            <div style="width:36px;height:36px;border-radius:9px;background:rgba(0,212,180,0.1);border:1px solid rgba(0,212,180,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="var(--teal)" stroke-width="2" stroke-linecap="round"><polyline points="3,8 6,11 13,5"/></svg>
            </div>
            <span style="font-size:0.85rem;color:var(--t2)">Real-time slot availability, no waitlists</span>
          </div>
          <div style="display:flex;align-items:center;gap:12px">
            <div style="width:36px;height:36px;border-radius:9px;background:rgba(0,212,180,0.1);border:1px solid rgba(0,212,180,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0">
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="var(--teal)" stroke-width="2" stroke-linecap="round"><polyline points="3,8 6,11 13,5"/></svg>
            </div>
            <span style="font-size:0.85rem;color:var(--t2)">Instant confirmation + smart reminders</span>
          </div>
        </div>
      </div>

      <div class="reveal">
        <div class="booking-card">
          <div class="bc-head">
            <div class="bc-head-title">Book Appointment</div>
            <div class="bc-avail">Today Available</div>
          </div>
          <div class="bc-body">
            <div class="doc-list">
              <div class="doc-item sel">
                <div class="doc-av" style="background:rgba(0,212,180,0.1)">????</div>
                <div>
                  <div class="doc-name">Dr. Priya Sharma</div>
                  <div class="doc-spec">Cardiologist � 12 yrs � Mumbai</div>
                </div>
                <div class="doc-rating">? 4.9</div>
              </div>
              <div class="doc-item">
                <div class="doc-av" style="background:rgba(14,165,233,0.1)">????</div>
                <div>
                  <div class="doc-name">Dr. Anil Mehta</div>
                  <div class="doc-spec">Neurologist � 9 yrs � Delhi</div>
                </div>
                <div class="doc-rating">? 4.8</div>
              </div>
              <div class="doc-item">
                <div class="doc-av" style="background:rgba(249,115,22,0.1)">????</div>
                <div>
                  <div class="doc-name">Dr. Kavya Nair</div>
                  <div class="doc-spec">Dermatologist � 7 yrs � Bengaluru</div>
                </div>
                <div class="doc-rating">? 4.7</div>
              </div>
            </div>

            <div class="slots-label">Available Slots ? Today</div>
            <div class="slots">
              <div class="slot">9:00 AM</div>
              <div class="slot active">10:30 AM</div>
              <div class="slot">2:00 PM</div>
              <div class="slot">3:30 PM</div>
              <div class="slot">5:00 PM</div>
              <div class="slot">6:30 PM</div>
            </div>

            <button class="btn-book">
              <svg viewBox="0 0 15 15"><rect x="2" y="3" width="11" height="11" rx="1.5"/><path d="M10 1v4M5 1v4M2 8h11"/><polyline points="5,10 6.5,11.5 10,9"/></svg>
              Confirm Booking
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>


<!-- ??? TESTIMONIALS ??? -->
<section class="section testi-section" id="contact">
  <div class="container">
    <div class="eyebrow">Patient Stories</div>
    <h2 class="section-title">Trusted by <span class="hi">thousands</span></h2>
    <p class="section-sub">Real experiences from patients and doctors who've transformed their healthcare journey.</p>

    <div class="testi-grid">
      <div class="tcard reveal">
        <div class="tcard-stars">
          <div class="star"></div><div class="star"></div><div class="star"></div><div class="star"></div><div class="star"></div>
        </div>
        <div class="tcard-quote">"The AI caught early signs of hypertension I wasn't aware of. The cardiologist recommended was fantastic. This platform literally changed ? and possibly saved ? my life."</div>
        <div class="tcard-author">
          <div class="tcard-av" style="background:rgba(0,212,180,0.1)">?</div>
          <div>
            <div class="tcard-name">Neha Kapoor</div>
            <div class="tcard-role">Software Engineer, Pune</div>
          </div>
        </div>
      </div>

      <div class="tcard reveal">
        <div class="tcard-stars">
          <div class="star"></div><div class="star"></div><div class="star"></div><div class="star"></div><div class="star"></div>
        </div>
        <div class="tcard-quote">"As a practising cardiologist, the doctor dashboard makes managing 30+ patients per day incredibly efficient. Digital prescriptions alone save me 2 hours daily."</div>
        <div class="tcard-author">
          <div class="tcard-av" style="background:rgba(14,165,233,0.08)">????</div>
          <div>
            <div class="tcard-name">Dr. Rajesh Iyer</div>
            <div class="tcard-role">Cardiologist, Mumbai</div>
          </div>
        </div>
      </div>

      <div class="tcard reveal">
        <div class="tcard-stars">
          <div class="star"></div><div class="star"></div><div class="star"></div><div class="star"></div><div class="star"></div>
        </div>
        <div class="tcard-quote">"Booking took less than 2 minutes. Reminders meant I never missed a follow-up. Video consultation saved hours of travel every single visit. Genuinely brilliant."</div>
        <div class="tcard-author">
          <div class="tcard-av" style="background:rgba(249,115,22,0.08)">?</div>
          <div>
            <div class="tcard-name">Suresh Patel</div>
            <div class="tcard-role">Retired Teacher, Ahmedabad</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>


<!-- ??? CTA ??? -->
<section class="cta-section">
  <div class="container">
    <div class="cta-box reveal">
      <div class="cta-inner">
        <div>
          <div class="eyebrow" style="color:rgba(0,212,180,0.8)">// Get Started Today</div>
          <h2 class="cta-title">Start your health journey.<br>It's completely free.</h2>
          <p class="cta-desc">Join 12,000+ patients and 480+ doctors on India's most intelligent healthcare platform. No credit card required.</p>
        </div>
        <div class="cta-btns">
          <button class="btn-cta-main" onclick="openModal()">
            <svg viewBox="0 0 15 15"><path d="M7.5 1v13M1 7.5h13" stroke-linecap="round"/></svg>
            Get Started Free
          </button>
          <a href="doctorRegister.jsp" class="btn-cta-ghost">
            <svg viewBox="0 0 14 14"><path d="M7 1a6 6 0 1 0 0 12A6 6 0 0 0 7 1z"/><path d="M7 4v6M4 7h6"/></svg>
            Join as Doctor
          </a>
        </div>
      </div>
    </div>
  </div>
</section>


<!-- ??? FOOTER ??? -->
<footer class="footer">
  <div class="container">
    <div class="footer-grid">
      <div>
        <div class="footer-brand">
          <div style="display:flex;align-items:center;gap:10px;margin-bottom:14px">
            <div class="logo-mark" style="width:30px;height:30px;border-radius:8px">
              <svg width="18" height="12" viewBox="0 0 22 14" fill="none" stroke="white" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="0,7 4,7 6,2 8,12 10,4 12,10 14,7 22,7"/>
              </svg>
            </div>
            <span class="logo-name">Health<em>OS</em></span>
          </div>
        </div>
        <p class="footer-desc">India's most advanced AI-powered healthcare platform ? bringing world-class doctors and patients together, effortlessly.</p>
      </div>

      <div>
        <div class="footer-col-title">Patients</div>
        <ul class="footer-links">
          <li><a href="userRegister.jsp">Register</a></li>
          <li><a href="userLogin.jsp">Login</a></li>
          <li><a href="#">Book Appointment</a></li>
          <li><a href="#">AI Symptom Check</a></li>
          <li><a href="#">Health Records</a></li>
        </ul>
      </div>

      <div>
        <div class="footer-col-title">Doctors</div>
        <ul class="footer-links">
          <li><a href="doctorRegister.jsp">Join Platform</a></li>
          <li><a href="doctorLogin.jsp">Doctor Login</a></li>
          <li><a href="#">Manage Patients</a></li>
          <li><a href="#">Prescriptions</a></li>
          <li><a href="#">Dashboard</a></li>
        </ul>
      </div>

      <div>
        <div class="footer-col-title">Company</div>
        <ul class="footer-links">
          <li><a href="#">About Us</a></li>
          <li><a href="#">Privacy Policy</a></li>
          <li><a href="#">Terms of Service</a></li>
          <li><a href="#">Contact</a></li>
          <li><a href="#">Blog</a></li>
        </ul>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="footer-copy">� 2025 HealthOS. All rights reserved. Built with ? in India.</div>
      <div class="social-links">
        <a class="soc-btn" href="#">
          <svg viewBox="0 0 14 14"><path d="M13 1L8 6.5 13 13H9.5L6.5 9.5 3 13H1l5.5-6L1 1h3.5l2.5 3.5L11 1z"/></svg>
        </a>
        <a class="soc-btn" href="#">
          <svg viewBox="0 0 14 14"><rect x="2" y="2" width="10" height="10" rx="2.5"/><circle cx="7" cy="7" r="2.5"/><circle cx="10" cy="4" r="0.6" fill="currentColor" stroke="none"/></svg>
        </a>
        <a class="soc-btn" href="#">
          <svg viewBox="0 0 14 14"><path d="M2 4h10M2 7h10M2 10h6"/></svg>
        </a>
        <a class="soc-btn" href="#">
          <svg viewBox="0 0 14 14"><path d="M2 2h4l2 4-2 2a9 9 0 0 0 4 4l2-2 4 2v4A2 2 0 0 1 14 14 12 12 0 0 1 0 2 2 2 0 0 1 2 0z"/></svg>
        </a>
      </div>
    </div>
  </div>
</footer>


<!-- ??? MODAL ??? -->
<div class="modal-overlay" id="modalOverlay">
  <div class="modal-box">
    <div class="modal-head">
      <div class="modal-title">
        <svg viewBox="0 0 18 18"><polyline points="0,9 4,9 6,2 8,14 10,5 12,11 14,9 18,9"/></svg>
        Welcome to HealthOS
      </div>
      <button class="modal-close" onclick="closeModal()">
        <svg viewBox="0 0 14 14"><line x1="2" y1="2" x2="12" y2="12"/><line x1="12" y1="2" x2="2" y2="12"/></svg>
      </button>
    </div>
    <div class="modal-body">
      <p class="modal-hint">How would you like to continue?</p>
      <div class="role-grid">
        <a href="userRegister.jsp" class="role-card rp">
          <div class="role-ico">
            <svg viewBox="0 0 26 26"><circle cx="13" cy="9" r="5"/><path d="M4 22c0-5 4-8 9-8s9 3 9 8"/></svg>
          </div>
          <div class="role-name">Patient</div>
          <div class="role-desc">Book appointments & get AI health predictions</div>
          <span class="role-badge">Register ?</span>
        </a>
        <a href="doctorRegister.jsp" class="role-card rd">
          <div class="role-ico">
            <svg viewBox="0 0 26 26"><path d="M9 3H7a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2h-2"/><rect x="9" y="1" width="8" height="4" rx="1"/><line x1="13" y1="11" x2="13" y2="17"/><line x1="10" y1="14" x2="16" y2="14"/></svg>
          </div>
          <div class="role-name">Doctor</div>
          <div class="role-desc">Manage patients & handle appointments online</div>
          <span class="role-badge">Register ?</span>
        </a>
      </div>
      <div class="modal-divider">already have an account</div>
      <div class="modal-login-links">
        <a href="userLogin.jsp" class="lp">Patient Login</a>
        <span>|</span>
        <a href="doctorLogin.jsp" class="ld">Doctor Login</a>
      </div>
    </div>
  </div>
</div>


<script>
/* ??? Cursor ??? */
const cur = document.getElementById('cursor');
const ring = document.getElementById('cursor-ring');
let mx=0,my=0,rx=0,ry=0;
document.addEventListener('mousemove',e=>{mx=e.clientX;my=e.clientY;cur.style.left=mx+'px';cur.style.top=my+'px'});
(function animRing(){rx+=(mx-rx)*0.12;ry+=(my-ry)*0.12;ring.style.left=rx+'px';ring.style.top=ry+'px';requestAnimationFrame(animRing)})();

/* ??? Navbar scroll shrink ??? */
const navWrap = document.querySelector('.nav-wrap');
window.addEventListener('scroll',()=>{
  navWrap.style.top = scrollY > 60 ? '10px' : '20px';
},{passive:true});

/* ??? Reveal on scroll ??? */
const revealEls = document.querySelectorAll('.reveal');
const revIO = new IntersectionObserver(entries=>{
  entries.forEach(e=>{
    if(e.isIntersecting){e.target.classList.remove('hidden');e.target.classList.add('visible');revIO.unobserve(e.target)}
  });
},{threshold:0.08,rootMargin:'0px 0px -20px 0px'});
revealEls.forEach(el=>{
  const r=el.getBoundingClientRect();
  if(r.top>window.innerHeight*0.95)el.classList.add('hidden');
  revIO.observe(el);
});

/* ??? Slot selection ??? */
document.querySelectorAll('.slot').forEach(s=>{
  s.addEventListener('click',()=>{
    document.querySelectorAll('.slot').forEach(x=>x.classList.remove('active'));
    s.classList.add('active');
  });
});

/* ??? Doctor selection ??? */
document.querySelectorAll('.doc-item').forEach(d=>{
  d.addEventListener('click',()=>{
    document.querySelectorAll('.doc-item').forEach(x=>x.classList.remove('sel'));
    d.classList.add('sel');
  });
});

/* ??? Counter animation ??? */
const cIO = new IntersectionObserver(entries=>{
  entries.forEach(e=>{
    if(!e.isIntersecting)return;
    const el=e.target,end=+el.dataset.target;
    let v=0;const step=end/60;
    const t=setInterval(()=>{
      v+=step;
      if(v>=end){el.textContent=end;clearInterval(t)}
      else el.textContent=Math.floor(v);
    },16);
    cIO.unobserve(el);
  });
},{threshold:0.5});
document.querySelectorAll('.counter').forEach(c=>cIO.observe(c));

/* ??? Modal ??? */
const overlay = document.getElementById('modalOverlay');
function openModal(){overlay.classList.add('show');document.body.style.overflow='hidden'}
function closeModal(){overlay.classList.remove('show');document.body.style.overflow=''}
overlay.addEventListener('click',e=>{if(e.target===overlay)closeModal()});
document.addEventListener('keydown',e=>{if(e.key==='Escape')closeModal()});

/* ??? Smooth scroll ??? */
document.querySelectorAll('a[href^="#"]').forEach(a=>{
  a.addEventListener('click',e=>{
    const t=document.querySelector(a.getAttribute('href'));
    if(t){e.preventDefault();t.scrollIntoView({behavior:'smooth'})}
  });
});

/* ??? 3D card tilt on mouse ??? */
const dashCard = document.querySelector('.dash-card');
const heroVisual = document.querySelector('.hero-visual');
if(heroVisual && dashCard){
  heroVisual.addEventListener('mousemove',e=>{
    const rect=heroVisual.getBoundingClientRect();
    const x=(e.clientX-rect.left)/rect.width-0.5;
    const y=(e.clientY-rect.top)/rect.height-0.5;
    dashCard.style.animation='none';
    dashCard.style.transform=`translate(-50%,-50%) perspective(1000px) rotateX(${-y*12}deg) rotateY(${x*16}deg)`;
  });
  heroVisual.addEventListener('mouseleave',()=>{
    dashCard.style.animation='cardFloat 8s ease-in-out infinite';
  });
}
</script>
</body>
</html>