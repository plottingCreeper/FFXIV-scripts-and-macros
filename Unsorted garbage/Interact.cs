using ECommons.Automation;
using ECommons.DalamudServices;
using PandorasBox.FeaturesSetup;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
﻿using ECommons.GameFunctions;
using FFXIVClientStructs.FFXIV.Client.Game.Control;
using FFXIVClientStructs.FFXIV.Client.Game.Object;
using ObjectKind = Dalamud.Game.ClientState.Objects.Enums.ObjectKind;
// Wrong wrong wrong. Fix soon™️.

namespace PandorasBox.Features.Commands
{
    public unsafe class InteractCommand : CommandFeature
    {
        public override string Name => "Interact with target command";
        public override string Command { get; set; } = "/interact";

        public override string Description => "Adds a command to interact with current target. Probably.";

        public override FeatureType FeatureType => FeatureType.Commands;
        protected override void OnCommand(List<string> args)
        {
            var x = Svc.Targets.Target;
            if (x != null)
            {
                if (Vector3.Distance(x.Position, Svc.ClientState.LocalPlayer.Position) < Utils.GetValidInteractionDistance(x) && x.IsTargetable())
                {
                    TargetSystem.Instance()->InteractWithObject((GameObject*)x.Address, false);
                    P.DebugLog($"Interacted with {x}");
                    return true;
                }
            }
        }
    }
}
